import { abi, address, config } from '@wagmi/test'
import { expect, test } from 'vitest'

import { connect } from '../../actions/connect.js'
import { disconnect } from '../../actions/disconnect.js'
import { writeContracts } from './writeContracts.js'

const connector = config.connectors[0]!

test('default', async () => {
  await connect(config, { connector })
  await expect(
    writeContracts(config, {
      contracts: [
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
      ],
    }),
  ).resolves.toMatchInlineSnapshot(
    `
    {
      "id": "0x8913636bd97cf4bcc0a6343c730905a27ead0f7480ff82190072e916439eb212",
    }
  `,
  )
  await disconnect(config, { connector })
})

test('behavior: not connected', async () => {
  await expect(
    writeContracts(config, {
      contracts: [
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
      ],
    }),
  ).rejects.toThrowErrorMatchingInlineSnapshot(`
    [TransactionExecutionError: HTTP request failed.

    Status: 400
    URL: http://127.0.0.1:8545/5111
    Request body: {"method":"eth_sendTransaction","params":[{"data":"0x1249c58b","to":"0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2","from":"0x95132632579b073D12a6673e18Ab05777a6B86f8"}]}
     
    Request Arguments:
      from:  0x95132632579b073D12a6673e18Ab05777a6B86f8

    Details: Bad Request
    Version: viem@2.44.0]
  `)
})

test('behavior: account does not exist on connector', async () => {
  await connect(config, { connector })
  await expect(
    writeContracts(config, {
      account: '0xA0Cf798816D4b9b9866b5330EEa46a18382f251e',
      contracts: [
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
        {
          abi: abi.wagmiMintExample,
          address: address.wagmiMintExample,
          functionName: 'mint',
        },
      ],
    }),
  ).rejects.toThrowErrorMatchingInlineSnapshot(`
    [ConnectorAccountNotFoundError: Account "0xA0Cf798816D4b9b9866b5330EEa46a18382f251e" not found for connector "Mock Connector".

    Version: @wagmi/core@x.y.z]
  `)
  await disconnect(config, { connector })
})
