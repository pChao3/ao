import Arweave from 'arweave';
import fs from 'node:fs';
import { message, createDataItemSigner, result, spawn, dryrun } from '@permaweb/aoconnect';

const llama = 'pazXumQI-HPH7iFGfTC-4_7biSnqz_U67oFAGry5zUY';
// const Game = 'sZe_mf4uJs1khzh0QZmNnaxdoXtBa51LRh2uhnDyk3Y';
const Game = 's32OLyMpNMCWbH-5UkW58hu554TtPU0CkAdwqBeYpNk'; // competition

// const fishman = 'M7njeaA88ynBogxsjQsyrT2Y_G51hcru1Kil4f0u8gg';
// const fishRod = 'gm9hLIm3kyWw_Itt1Ub494lFStZoUbOAeZreDfOR2t8';
// const fishRod = 'j-oQy3ZH4H3Lc50qrv-dSFQJwbGMOCfK3C0Z1g-ypPA'; // #19
const fishRod = 'eF11vbG60L6dTtH4FGElfncuZM3RNS-LlcMs8AHHr_0'; // #13

// 初始化 Arweave 客户端
const arweave = Arweave.init({
  host: 'ar-io.dev',
  port: 443,
  protocol: 'https',
});

const keyfile = JSON.parse(fs.readFileSync('./example.json').toString());
const walletAddress = await arweave.wallets.jwkToAddress(keyfile);

// console.log(keyfile, walletAddress);
// Target = llama,Action = "Transfer",Recipient = Game,Quantity = "10000000000000",["X-Sender-Name"]="dum",["X-Note"]="Enroll"
const buyFishFood = async () => {
  await message({
    process: llama,
    tags: [
      { name: 'Action', value: 'Transfer' },
      { name: 'Recipient', value: Game },
      { name: 'Quantity', value: '100000000000000' },
      { name: 'X-Sender-Name', value: 'crazyDumDumZ' },
      { name: 'X-Note', value: 'Enroll' },
    ],
    signer: createDataItemSigner(keyfile),
  });
  await sleep(5000);
  await loop();
};

const loop = async () => {
  console.log('----start get fish ----');
  for (let i = 1; i <= 20; i++) {
    const id = await message({
      process: fishRod,
      tags: [{ name: 'Action', value: 'DefaultInteraction' }],
      signer: createDataItemSigner(keyfile),
    });
    console.log(`${i} : ${id}`);
    await sleep(5000);
  }
  console.log('---batch ended---');
};

const sleep = time => {
  console.log(`----await ${time / 1000} deconds-----`);

  return new Promise(resolve => setTimeout(resolve, time));
};

const setLoopTimes = async time => {
  for (let i = 1; i <= time; i++) {
    console.log(`------------------第${i}批次循环开始---------------------`);
    await buyFishFood();
    console.log(`------------------第${i}批次循环结束---------------------`);
  }
};

setLoopTimes(1);

// const a = async () => {
//   await message({
//     process: Game,
//     tags: [{ name: 'Action', value: 'Leaderboard' }],
//     signer: createDataItemSigner(keyfile),
//   });
// };
// a();
