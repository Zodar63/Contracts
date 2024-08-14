import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import dotenv from "dotenv";
dotenv.config();

const defaultKey = "0000000000000000000000000000000000000000000000000000000000000001";
const defaultRpcUrl = "http://localhost:8545";

const config: HardhatUserConfig = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 1337
        },
        sepolia: {
            url: process.SEPOLIA_RPC_URL || defaultRpcUrl,
            accounts: {
                mnemonic: process.env.MNEMONIC || defaultKey,
                path: "m/44'/60'/0'/0",
                initialIndex: 0, // 0x6e38e66E0A6eEeF959e27742e99482a3f12FEB91
                count: 20,
                passphrase: ""
            }
        },
        arbitrum: {
            url: process.ARBITRUM_RPC_URL || defaultRpcUrl,
            accounts: {
                mnemonic: process.env.MNEMONIC || defaultKey,
                path: "m/44'/60'/0'/0",
                initialIndex: 0, // 0x6e38e66E0A6eEeF959e27742e99482a3f12FEB91
                count: 20,
                passphrase: ""
            }
        },
        immutableZkevmTestnet: {
            url: process.IMMUTABLE_ZKEVM_TESTNET_RPC_URL || defaultRpcUrl,
            accounts: [process.env.PRIVATE_KEY || defaultKey],
            // ignition: {
            //     maxFeePerGasLimit: BigInt(10000000),
            //     maxPriorityFeePerGas: BigInt(1000000)
            // },
            chainId: 13473
        },
        telos: {
            url: "https://mainnet.telos.net/evm",
            accounts: [process.env.PRIVATE_KEY || defaultKey],
            chainId: 40
        },
        telosTestnet: {
            url: "https://testnet.telos.net/evm",
            accounts: [process.env.PRIVATE_KEY || defaultKey],
            chainId: 41
        }
    },
    solidity: {
        version: "0.8.20",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts"
    },
    mocha: {
        timeout: 40000
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY
    },
};

export default config;
