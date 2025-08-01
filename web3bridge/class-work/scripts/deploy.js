const hre = require("hardhat");

async function main() {
  console.log("Deploying to Lisk Sepolia...");

  // Deploy PointingContract
  const PointingContract = await hre.ethers.getContractFactory("PointingContract");
  const pointingContract = await PointingContract.deploy();
  await pointingContract.waitForDeployment();
  
  const pointingAddress = await pointingContract.getAddress();
  console.log("PointingContract deployed to:", pointingAddress);

  // Deploy PrizeClaimContract
  const PrizeClaimContract = await hre.ethers.getContractFactory("PrizeClaimContract");
  const prizeClaimContract = await PrizeClaimContract.deploy(pointingAddress);
  await prizeClaimContract.waitForDeployment();
  
  const prizeClaimAddress = await prizeClaimContract.getAddress();
  console.log("PrizeClaimContract deployed to:", prizeClaimAddress);

  console.log("\nDeployment Summary:");
  console.log("==================");
  console.log("PointingContract:", pointingAddress);
  console.log("PrizeClaimContract:", prizeClaimAddress);
  console.log("Network: Lisk Sepolia");
  console.log("Chain ID: 4202");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });