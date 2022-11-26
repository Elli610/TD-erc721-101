var HelloWorld=artifacts.require ("MyFirstERC721");
module.exports = function(deployer) {
      deployer.deploy(HelloWorld);
}