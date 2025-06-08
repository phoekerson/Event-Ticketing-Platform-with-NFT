'use client'
import { ConnectButton } from "@rainbow-me/rainbowkit"
import { Flex, Text } from "@chakra-ui/react"
const Header = () => {
  return (
    <Flex
        p="2rem"
        justifyContent="space-between">
            <Text as='b'>Logo</Text>
        <ConnectButton/>

    </Flex>
    )
}

export default Header
