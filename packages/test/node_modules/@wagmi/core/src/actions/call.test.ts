import { accounts, address, config } from '@wagmi/test'
import { parseEther, parseGwei } from 'viem'
import { expect, test } from 'vitest'

import { call } from './call.js'

const name4bytes = '0x06fdde03'
const mint4bytes = '0x1249c58b'
const mintWithParams4bytes = '0xa0712d68'
const fourTwenty =
  '00000000000000000000000000000000000000000000000000000000000001a4'

const account = accounts[0]

test('default', async () => {
  await expect(
    call(config, {
      account,
      data: name4bytes,
      to: address.wagmiMintExample,
    }),
  ).resolves.toMatchInlineSnapshot(`
  {
    "data": "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000057761676d69000000000000000000000000000000000000000000000000000000",
  }
  `)
})

test('zero data', async () => {
  await expect(
    call(config, {
      account,
      data: mint4bytes,
      to: address.wagmiMintExample,
    }),
  ).resolves.toMatchInlineSnapshot(`
  {
    "data": undefined,
  }
  `)
})

// TODO: Re-enable
test.skip('parameters: blockNumber', async () => {
  await expect(
    call(config, {
      account,
      data: name4bytes,
      to: address.wagmiMintExample,
      blockNumber: 16280770n,
    }),
  ).resolves.toMatchInlineSnapshot(`
  {
    "data": "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000057761676d69000000000000000000000000000000000000000000000000000000",
  }
  `)
})

test('insufficient funds', async () => {
  await expect(
    call(config, {
      account,
      to: accounts[1],
      value: parseEther('100000'),
    }),
  ).rejects.toThrowErrorMatchingInlineSnapshot(`
    [CallExecutionError: HTTP request failed.

    Status: 400
    URL: http://127.0.0.1:8545/4346
    Request body: {"method":"eth_call","params":[{"from":"0x95132632579b073D12a6673e18Ab05777a6B86f8","to":"0x1D5D7e139A994CeE7f360be398Ef032fE5D74fce","value":"0x152d02c7e14af6800000"},"latest"]}
     
    Raw Call Arguments:
      from:   0x95132632579b073D12a6673e18Ab05777a6B86f8
      to:     0x1D5D7e139A994CeE7f360be398Ef032fE5D74fce
      value:  100000 ETH

    Details: Bad Request
    Version: viem@2.44.0]
  `)
})

test('maxFeePerGas less than maxPriorityFeePerGas', async () => {
  await expect(
    call(config, {
      account,
      data: name4bytes,
      to: address.wagmiMintExample,
      maxFeePerGas: parseGwei('20'),
      maxPriorityFeePerGas: parseGwei('22'),
    }),
  ).rejects.toThrowErrorMatchingInlineSnapshot(`
    [CallExecutionError: The provided tip (\`maxPriorityFeePerGas\` = 22 gwei) cannot be higher than the fee cap (\`maxFeePerGas\` = 20 gwei).

    Raw Call Arguments:
      from:                  0x95132632579b073D12a6673e18Ab05777a6B86f8
      to:                    0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2
      data:                  0x06fdde03
      maxFeePerGas:          20 gwei
      maxPriorityFeePerGas:  22 gwei

    Version: viem@2.44.0]
  `)
})

test('contract revert (contract error)', async () => {
  await expect(
    call(config, {
      account,
      data: `${mintWithParams4bytes}${fourTwenty}`,
      to: address.wagmiMintExample,
    }),
  ).rejects.toThrowErrorMatchingInlineSnapshot(`
    [CallExecutionError: HTTP request failed.

    Status: 400
    URL: http://127.0.0.1:8545/4346
    Request body: {"method":"eth_call","params":[{"data":"0xa0712d6800000000000000000000000000000000000000000000000000000000000001a4","from":"0x95132632579b073D12a6673e18Ab05777a6B86f8","to":"0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2"},"latest"]}
     
    Raw Call Arguments:
      from:  0x95132632579b073D12a6673e18Ab05777a6B86f8
      to:    0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2
      data:  0xa0712d6800000000000000000000000000000000000000000000000000000000000001a4

    Details: Bad Request
    Version: viem@2.44.0]
  `)
})

test('contract revert (insufficient params)', async () => {
  await expect(
    call(config, {
      account,
      data: mintWithParams4bytes,
      to: address.wagmiMintExample,
    }),
  ).rejects.toThrowErrorMatchingInlineSnapshot(`
    [CallExecutionError: HTTP request failed.

    Status: 400
    URL: http://127.0.0.1:8545/4346
    Request body: {"method":"eth_call","params":[{"data":"0xa0712d68","from":"0x95132632579b073D12a6673e18Ab05777a6B86f8","to":"0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2"},"latest"]}
     
    Raw Call Arguments:
      from:  0x95132632579b073D12a6673e18Ab05777a6B86f8
      to:    0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2
      data:  0xa0712d68

    Details: Bad Request
    Version: viem@2.44.0]
  `)
})
