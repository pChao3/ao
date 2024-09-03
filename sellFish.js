import Arweave from 'arweave';
import fs from 'node:fs';
import path from 'node:path';
import { message, createDataItemSigner, result, spawn, dryrun } from '@permaweb/aoconnect';

const world = '2dFSGGlc5xJb0sWinAnEFHM-62tQEbhDzi1v5ldWX5k'; // llama list
const llama = 'pazXumQI-HPH7iFGfTC-4_7biSnqz_U67oFAGry5zUY';
const Game = 'sZe_mf4uJs1khzh0QZmNnaxdoXtBa51LRh2uhnDyk3Y';
const fishRod = 'gm9hLIm3kyWw_Itt1Ub494lFStZoUbOAeZreDfOR2t8';

const fishType = [
  'BC4KnHcT4YnonwToJATLabIJRGIYdYxY2-KnHbe1tN0',
  'HsR53ViqEyHMyAdv5Utz8fV_QRlmpMcaP4Py0R2ZgRM',
  // 'ENNFBJS_TpBTh-xR648Pdpx2Z8YgZkRbiqbuzfVv0M4',
];

// 初始化 Arweave 客户端
const arweave = Arweave.init({
  host: 'ar-io.dev',
  port: 443,
  protocol: 'https',
});

const keyfile = JSON.parse(fs.readFileSync('./example.json').toString());
const walletAddress = await arweave.wallets.jwkToAddress(keyfile);

const sellFish = async () => {
  console.log('-start sell fish--');
  for (let i = 0; i < fishType.length; i++) {
    await loopSell(fishType[i]);
  }

  console.log('--fish sale success !--');
};

const loopSell = async processId => {
  const data = await dryrun({
    process: processId,
    tags: [
      { name: 'Action', value: 'Balance' },
      { name: 'Target', value: walletAddress },
    ],
  });

  //{Target=commonFish, Action="Transfer",Quantity=msg.Data1, Recipient=Game})
  if (data.Messages[0] && Number(data.Messages[0].Data) > 0) {
    await message({
      process: processId,
      tags: [
        { name: 'Action', value: 'Transfer' },
        { name: 'Quantity', value: data.Messages[0].Data },
        { name: 'Recipient', value: Game },
      ],
      signer: createDataItemSigner(keyfile),
    });
  }
  await sleep(3000);
};

const sleep = time => {
  console.log(`----await ${time / 1000} seconds-----`);
  return new Promise(resolve => setTimeout(resolve, time));
};

sellFish();
