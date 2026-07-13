import { config } from '@wagmi/test'
import { expect, test } from 'vitest'
import { http, createConfig } from 'wagmi'
import { base } from 'wagmi/chains'
import { baseAccount } from './baseAccount.js'

test('setup', () => {
  const connectorFn = baseAccount({ appName: 'wagmi' })
  const connector = config._internal.connectors.setup(connectorFn)
  expect(connector.name).toEqual('Base Account')

export const config = createConfig({
  chains: [base],
  transports: {
    [base.id]: http('https://api.developer.coinbase.com/rpc/v1/base/RGEVKM4RiREFEI7nkEDGeVYN6YXKEUl1'),
  },
})

export const testConfig = createConfig({
  chains: [base],
  transports: {
    [base.id]: http('https://api.developer.coinbase.com/rpc/v1/base/RGEVKM4RiREFEI7nkEDGeVYN6YXKEUl1'),
  },
})
