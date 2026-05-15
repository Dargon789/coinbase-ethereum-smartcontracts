import { abi, address, config } from '@wagmi/test'
import { expect, test } from 'vitest'

import { multicall } from './multicall.js'

test('default', async () => {
  await expect(
    multicall(config, {
      contracts: [
        {
          address: address.wagmiMintExample,
          abi: abi.wagmiMintExample,
          functionName: 'balanceOf',
          args: ['0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC'],
        },
      ],
    }),
  ).resolves.toMatchInlineSnapshot(`
    [
      {
        "error": [ContractFunctionExecutionError: HTTP request failed.

    Status: 400
    URL: http://127.0.0.1:8545/9306
    Request body: {"method":"eth_call","params":[{"data":"0x82ad56cb000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000fba3912ca04dd458c843e2ee08967fc04f3579c200000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000002470a08231000000000000000000000000a5cc3c03994db5b0d9a5eedd10cabab0813678ac00000000000000000000000000000000000000000000000000000000","to":"0xca11bde05977b3631167028862be2a173976ca11"},"latest"]}
     
    Raw Call Arguments:
      to:    0xca11bde05977b3631167028862be2a173976ca11
      data:  0x82ad56cb000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000fba3912ca04dd458c843e2ee08967fc04f3579c200000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000002470a08231000000000000000000000000a5cc3c03994db5b0d9a5eedd10cabab0813678ac00000000000000000000000000000000000000000000000000000000
     
    Contract Call:
      address:   0xca11bde05977b3631167028862be2a173976ca11
      function:  aggregate3((address target, bool allowFailure, bytes callData)[])
      args:                ([{"allowFailure":true,"callData":"0x70a08231000000000000000000000000a5cc3c03994db5b0d9a5eedd10cabab0813678ac","target":"0xFBA3912Ca04dd458c843e2EE08967fC04f3579c2"}])

    Docs: https://viem.sh/docs/contract/readContract
    Details: Bad Request
    Version: viem@2.44.0],
        "result": undefined,
        "status": "failure",
      },
    ]
  `)
})

test('allowFailure', async () => {
  await expect(
    multicall(config, {
      allowFailure: false,
      contracts: [
        {
          address: address.wagmiMintExample,
          abi: abi.wagmiMintExample,
          functionName: 'balanceOf',
          args: ['0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC'],
        },
      ],
    }),
  ).resolves.toMatchInlineSnapshot(`
    [
      10n,
    ]
  `)
})
