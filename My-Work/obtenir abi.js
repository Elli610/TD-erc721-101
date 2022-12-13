const fs = require('fs');
const contract = JSON.parse(fs.readFileSync('./build/contracts/MyFirstERC721.json', 'utf8'));
console.log(JSON.stringify(contract.abi));