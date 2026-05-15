import { accounts, config, privateKey, typedData } from '@wagmi/test'
import { recoverTypedDataAddress } from 'viem'
import { privateKeyToAccount } from 'viem/accounts'
import { expect, test } from 'vitest'
import { mock } from '../connectors/mock.js'
import { connect } from './connect.js'
import { disconnect } from './disconnect.js'
import { getConnection } from './getConnection.js'
import { signTypedData } from './signTypedData.js'

const connector = config.connectors[0]!

test('default', async () => {
  await connect(config, { connector })
  const signature = await signTypedData(config, {
    types: typedData.basic.types,
    primaryType: 'Mail',
    message: typedData.basic.message,
  })
  await expect(
    recoverTypedDataAddress({
      types: typedData.basic.types,
      primaryType: 'Mail',
      message: typedData.basic.message,
      signature,
    }),
  ).resolves.toBe(getConnection(config).address)
  await disconnect(config, { connector })
})

test('behavior: user rejected request', async () => {
  const connector_ = config._internal.connectors.setup(
    mock({
      accounts,
      features: { signTypedDataError: true },
    }),
  )
  await connect(config, { connector: connector_ })
  await expect(
    signTypedData(config, {
      types: typedData.basic.types,
      primaryType: 'Mail',
      message: typedData.basic.message,
    }),
  ).rejects.toMatchInlineSnapshot(`
    [UserRejectedRequestError: User rejected the request.

    Details: Failed to sign typed data.
    Version: viem@2.44.0]
  `)
  await disconnect(config, { connector: connector_ })
})

test('behavior: not connected', async () => {
  await expect(
    signTypedData(config, {
      types: typedData.basic.types,
      primaryType: 'Mail',
      message: typedData.basic.message,
    }),
  ).rejects.toMatchInlineSnapshot(`
    [HttpRequestError: HTTP request failed.

    Status: 400
    URL: http://127.0.0.1:8545/5217
    Request body: {"method":"eth_signTypedData_v4","params":["0x95132632579b073D12a6673e18Ab05777a6B86f8","{\\"domain\\":{},\\"message\\":{\\"from\\":{\\"name\\":\\"Cow\\",\\"wallet\\":\\"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826\\"},\\"to\\":{\\"name\\":\\"Bob\\",\\"wallet\\":\\"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB\\"},\\"contents\\":\\"Hello, Bob!\\"},\\"primaryType\\":\\"Mail\\",\\"types\\":{\\"EIP712Domain\\":[],\\"Person\\":[{\\"name\\":\\"name\\",\\"type\\":\\"string\\"},{\\"name\\":\\"wallet\\",\\"type\\":\\"address\\"}],\\"Mail\\":[{\\"name\\":\\"from\\",\\"type\\":\\"Person\\"},{\\"name\\":\\"to\\",\\"type\\":\\"Person\\"},{\\"name\\":\\"contents\\",\\"type\\":\\"string\\"}]}}"]}

    Details: Bad Request
    Version: viem@2.44.0]
  `)
})

test('behavior: local account', async () => {
  const account = privateKeyToAccount(privateKey)
  const signature = await signTypedData(config, {
    account,
    types: typedData.basic.types,
    primaryType: 'Mail',
    message: typedData.basic.message,
  })
  await expect(
    recoverTypedDataAddress({
      types: typedData.basic.types,
      primaryType: 'Mail',
      message: typedData.basic.message,
      signature,
    }),
  ).resolves.toBe(account.address)
})
