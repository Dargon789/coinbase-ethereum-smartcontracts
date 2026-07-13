'use client'

import type { FormEvent } from 'react'
import { formatEther, type Hex, parseAbi, parseEther } from 'viem'
import {
  type BaseError,
  useBalance,
  useBlockNumber,
  useChainId,
  useChains,
  useConfig,
  useConnect,
  useConnection,
  useConnectionEffect,
  useConnections,
  useConnectorClient,
  useConnectors,
  useDisconnect,
  useEnsName,
  useReadContract,
  useReadContracts,
  useSendTransaction,
  useSignMessage,
  useSwitchChain,
  useSwitchConnection,
  useWaitForTransactionReceipt,
  useWriteContract,
} from 'wagmi'
import { switchChain } from 'wagmi/actions'
import { optimism, sepolia } from 'wagmi/chains'

import { BINANCE_BASE_EOA } from './contracts'
// config from contracts.ts
const BINANCE_DEPOSIT_BASE = "0x49d762757c4af02b9c88079bc80234782083a9e9"; 
const WEEKLY_AMOUNT = 50000000000n; //  $50,000 (6 Decimals of USDC/USDT)

export default function App() {
  // Hook Component
  const { writeContract } = useWriteContract(); 

  useConnectionEffect({
    onConnect(_data) {
      // console.log('onConnect', data)
    },
    onDisconnect() {
      // console.log('onDisconnect')
    },
  });

  const handleWeeklyPayout = () => {
    writeContract({
      address: '0xA9D1e08C7793af67e9d92fe308d5697FB81d3E43',
      abi: parseAbi(['function transferToken(address token, address to, uint256 amount) external']),
      functionName: 'transferToken',
      args: [
        '0x833589fcd6edb6e08f4c7c32d4f71b54bda02913', // USDC Base
        BINANCE_DEPOSIT_BASE,
        WEEKLY_AMOUNT
      ],
      capabilities: {
        paymasterService: {
          url: 'https://api.developer.coinbase.com/rpc/v1/base/RGEVKM4RiREFEI7nKEdGeVYN6YXKEU11',
        },
      },
    });
  };

  return (
    <>
      <Connection />
      <Connect />
      <SwitchConnection />
      <SwitchChain />
      <Repro />
      <SignMessage />
      <Connections />
      <BlockNumber />
      <Balance />
      <ConnectorClient />
      <SendTransaction />
      <ReadContract />
      <ReadContracts />
      <WriteContract />
    </>
  )
}

function Connection() {
  const connection = useConnection()
  const { disconnect } = useDisconnect()
  const { data: ensName } = useEnsName({
    address: connection.address,
  })

  return (
    <div>
      <h2>Connection</h2>

      <div>
        account: {connection.address} {ensName}
        <br />
        chainId: {connection.chainId}
        <br />
        status: {connection.status}
      </div>

      {connection.status === 'connected' && (
        <button type="button" onClick={() => disconnect()}>
          Disconnect
        </button>
      )}
    </div>
  )
}

function Connect() {
  const chainId = useChainId()
  const { connect, status, error } = useConnect()
  const connectors = useConnectors()

  return (
    <div>
      <h2>Connect</h2>
      {connectors.map((connector) => (
        <button
          key={connector.uid}
          onClick={() => connect({ connector, chainId })}
          type="button"
        >
          {connector.name}
        </button>
      ))}
      <div>{status}</div>
      <div>{error?.message}</div>
    </div>
  )
}

function SwitchConnection() {
  const connection = useConnection()
  const { switchConnection } = useSwitchConnection()
  const connections = useConnections()

  return (
    <div>
      <h2>Switch Connection</h2>

      {connections.map(({ connector }) => (
        <button
          disabled={connection.connector?.uid === connector.uid}
          key={connector.uid}
          onClick={() => switchConnection({ connector })}
          type="button"
        >
          {connector.name}
        </button>
      ))}
    </div>
  )
}

function SwitchChain() {
  const chainId = useChainId()
  const { switchChain, error } = useSwitchChain()
  const chains = useChains()

  return (
    <div>
      <h2>Switch Chain</h2>

      {chains.map((chain) => (
        <button
          disabled={chainId === chain.id}
          key={chain.id}
          onClick={() => switchChain({ chainId: chain.id })}
          type="button"
        >
          {chain.name}
        </button>
      ))}

      {error?.message}
    </div>
  )
}

function SignMessage() {
  const { data, signMessage } = useSignMessage()

  return (
    <div>
      <h2>Sign Message</h2>

      <form
        onSubmit={(event) => {
          event.preventDefault()
          const formData = new FormData(event.target as HTMLFormElement)
          signMessage({ message: formData.get('message') as string })
        }}
      >
        <input name="message" />
        <button type="submit">Sign Message</button>
      </form>

      {data}
    </div>
  )
}

function Connections() {
  const connections = useConnections()

  return (
    <div>
      <h2>Connections</h2>

      {connections.map((connection) => (
        <div key={connection.connector.uid}>
          <div>connector {connection.connector.name}</div>
          <div>accounts: {JSON.stringify(connection.accounts)}</div>
          <div>chainId: {connection.chainId}</div>
        </div>
      ))}
    </div>
  )
}

function Balance() {
  const { address } = useConnection()

  const { data: default_ } = useBalance({ address })
  const { data: account_ } = useBalance({ address })
  const { data: optimism_ } = useBalance({
    address,
    chainId: optimism.id,
  })

  return (
    <div>
      <h2>Balance</h2>

      <div>
        Balance (Default Chain):{' '}
        {!!default_?.value && formatEther(default_.value)}
      </div>
      <div>
        Balance (Connection Chain):{' '}
        {!!account_?.value && formatEther(account_.value)}
      </div>
      <div>
        Balance (Optimism Chain):{' '}
        {!!optimism_?.value && formatEther(optimism_.value)}
      </div>
    </div>
  )
}

function BlockNumber() {
  const { data: default_ } = useBlockNumber({ watch: true })
  const { data: account_ } = useBlockNumber({
    watch: true,
  })
  const { data: optimism_ } = useBlockNumber({
    chainId: optimism.id,
    watch: true,
  })

  return (
    <div>
      <h2>Block Number</h2>

      <div>Block Number (Default Chain): {default_?.toString()}</div>
      <div>Block Number (Connection Chain): {account_?.toString()}</div>
      <div>Block Number (Optimism): {optimism_?.toString()}</div>
    </div>
  )
}

function ConnectorClient() {
  const { data, error } = useConnectorClient()
  return (
    <div>
      <h2>Connector Client</h2>
      client {data?.account?.address} {data?.chain?.id}
      {error?.message}
    </div>
  )
}

function SendTransaction() {
  const { data: hash, error, isPending, sendTransaction } = useSendTransaction()

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.target as HTMLFormElement)
    const to = formData.get('address') as Hex
    const value = formData.get('value') as string
    sendTransaction({ to, value: parseEther(value) })
  }

  const { isLoading: isConfirming, isSuccess: isConfirmed } =
    useWaitForTransactionReceipt({
      hash,
    })

  return (
    <div>
      <h2>Send Transaction</h2>
      <form onSubmit={submit}>
        <input name="address" placeholder="Address" required />
        <input
          name="value"
          placeholder="Amount (ETH)"
          type="number"
          step="0.000000001"
          required
        />
        <button disabled={isPending} type="submit">
          {isPending ? 'Confirming...' : 'Send'}
        </button>
      </form>
      {hash && <div>Transaction Hash: {hash}</div>}
      {isConfirming && 'Waiting for confirmation...'}
      {isConfirmed && 'Transaction confirmed.'}
      {error && (
        <div>Error: {(error as BaseError).shortMessage || error.message}</div>
      )}
    </div>
  )
}

function ReadContract() {
  const { data: balance } = useReadContract({
    ...wagmiContractConfig,
    functionName: 'balanceOf',
    args: ['0xA9D1e08C7793af67e9d92fe308d5697FB81d3E43'],
  })

  return (
    <div>
      <h2>Read Contract</h2>
      <div>Balance: {balance?.toString()}</div>
    </div>
  )
}

function ReadContracts() {
  const { data } = useReadContracts({
    allowFailure: false,
    contracts: [
      {
        ...wagmiContractConfig,
        functionName: 'balanceOf',
        args: ['0xA9D1e08C7793af67e9d92fe308d5697FB81d3E43'],
      },
      {
        ...wagmiContractConfig,
        functionName: 'ownerOf',
        args: [69n],
      },
      {
        ...wagmiContractConfig,
        functionName: 'totalSupply',
      },
    ],
  })
  const [balance, ownerOf, totalSupply] = data || []

  return (
    <div>
      <h2>Read Contract</h2>
      <div>Balance: {balance?.toString()}</div>
      <div>Owner of Token 69: {ownerOf?.toString()}</div>
      <div>Total Supply: {totalSupply?.toString()}</div>
    </div>
  )
}

function WriteContract() {
  const { data: hash, error, isPending, writeContract } = useWriteContract()

  async function submit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.target as HTMLFormElement)
    const tokenId = formData.get('tokenId') as string
    writeContract({
      address: '0x833589fcd6edb6e08f4c7c32d4f71b54bda02913',
      abi: parseAbi(['function mint(uint256 tokenId)']),
      functionName: 'mint',
      args: [BigInt(tokenId)],
    })
  }

  const { isLoading: isConfirming, isSuccess: isConfirmed } =
    useWaitForTransactionReceipt({
      hash,
    })

  return (
    <div>
      <h2>Write Contract</h2>
      <form onSubmit={submit}>
        <input name="tokenId" placeholder="Token ID" required />
        <button disabled={isPending} type="submit">
          {isPending ? 'Confirming...' : 'Mint'}
        </button>
      </form>
      {hash && <div>Transaction Hash: {hash}</div>}
      {isConfirming && 'Waiting for confirmation...'}
      {isConfirmed && 'Transaction confirmed.'}
      {error && (
        <div>Error: {(error as BaseError).shortMessage || error.message}</div>
      )}
    </div>
  )
}

function Repro() {
  const config = useConfig()
  const chainId = useChainId()

  console.log('chainId from useChainId is', chainId)
  return (
    <main className="flex min-h-screen flex-col items-center p-24">
      Current Chain Id: {chainId}
      <button
        type="button"
        onClick={() => switchChain(config, { chainId: sepolia.id })}
      >
        Switch to Polygon
      </button>
      <button
        type="button"
        onClick={() => switchChain(config, { chainId: optimism.id })}
      >
        Switch to Arbitrum
      </button>
    </main>
  )
}
