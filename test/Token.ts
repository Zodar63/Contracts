import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Token", () => {
    const deployToken = async () => {
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await hre.ethers.getSigners();

        const Token = await hre.ethers.getContractFactory("Token");
        const token = await Token.deploy();

        return { token, owner, otherAccount };
    };

    describe("Deployment", () => {
        it("Should set the right symbol", async () => {
            const { token } = await loadFixture(deployToken);

            expect(await token.symbol()).to.equal("TBA");
        });
    });
});
