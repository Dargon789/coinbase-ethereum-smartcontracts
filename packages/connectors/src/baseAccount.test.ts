import { config } from '@wagmi/test'
import { expect, test } from 'vitest'
import { http, createConfig } from 'wagmi'
import { base } from 'wagmi/chains'
import { baseAccount } from './baseAccount.js'

test('setup', () => {
  const connectorFn = baseAccount({ appName: 'wagmi' })
  const connector = config._internal.connectors.setup(connectorFn)
  expect(connector.name).toEqual('Base Account')
})
