const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const Auction = await ethers.getContractFactory("Auction");
    const auction = await Auction.deploy();

    await auction.deployed();

    console.log("auction deployed to address: ", auction.address);
    console.log("auction deployed to block: ", await hre.ethers.provider.getBlockNumber());
    console.log("auction owner is: ", await (auction.provider.getSigner() ).getAddress() );
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })
