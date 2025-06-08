'use client';
import '@rainbow-me/rainbowkit/styles.css';
import {Provider} from "../components/ui/provider"
import {
  getDefaultConfig,
  RainbowKitProvider,
} from '@rainbow-me/rainbowkit';
import { WagmiProvider } from 'wagmi';
import {
  hardhat
} from 'wagmi/chains';
import {
  QueryClientProvider,
  QueryClient,
} from "@tanstack/react-query";

const config = getDefaultConfig({
  appName: 'My RainbowKit App',
  projectId: 'process.env.NEXT_PUBLIC_WALLETCONNECT_ID',
  chains: [hardhat],
  ssr: true, // If your dApp uses server side rendering (SSR)
});
const queryClient = new QueryClient();
export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>    
      <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
         <RainbowKitProvider>  
          <Provider>
            {children}
          </Provider>
         </RainbowKitProvider>
      </QueryClientProvider>
      </WagmiProvider>

      </body>
    </html>
  );
}
