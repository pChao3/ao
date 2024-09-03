import Arweave from 'arweave';
import fs from 'node:fs';
import path from 'node:path';
import { message, createDataItemSigner, result, spawn, dryrun } from '@permaweb/aoconnect';

const world = '2dFSGGlc5xJb0sWinAnEFHM-62tQEbhDzi1v5ldWX5k'; // llama list
const arToken = 'xU9zFkq3X2ZQ6olwNVvr1vUWIjc3kXTWr7xKQD6dh10'; // war
const llamaKing = 'ptvbacSmqJPfgCXxPc9bcobs5Th2B_SxTf81vRNkRzk'; // llama King
const names = [
  'Panday',
  'midnightX',
  'ZOC',
  'echoWhirl',
  'Mr-Hans',
  'mellow',
  'blazeWorm12',
  'Try',
  'forg-end',
];

// 初始化 Arweave 客户端
const arweave = Arweave.init({
  host: 'ar-io.dev',
  port: 443,
  protocol: 'https',
});

const keyfileDir = './secretKeys'; // keyfile 文件存放的目录
console.log(keyfileDir);

fs.readdir(keyfileDir, async (err, files) => {
  if (err) {
    console.error('无法读取目录:', err);
    return;
  }

  for (let i = 0; i < files.length; i++) {
    const keyfilePath = path.join(keyfileDir, files[i]);
    const keyfile = JSON.parse(fs.readFileSync(keyfilePath, 'utf-8'));
    // await SignIn(keyfile); //每日签到
    await Petition(keyfile, names[i]); // 每日请愿
  }
  console.log('-------all finished -------');
});

const SignIn = async keyfile => {
  const msgId = await message({
    process: world,
    tags: [{ name: 'Action', value: 'Tracking-Login' }],
    signer: createDataItemSigner(keyfile),
  });
  const walletAddress = await arweave.wallets.jwkToAddress(keyfile);
  console.log(`${walletAddress} : Login Success!`);
};

// petition
const Petition = async (keyfile, name) => {
  for (let i = 0; i < 3; i++) {
    const msgId = await message({
      process: arToken,
      tags: [
        { name: 'Action', value: 'Transfer' },
        { name: 'Quantity', value: '25000000000' },
        { name: 'Recipient', value: llamaKing },
        {
          name: 'X-Petition',
          value:
            'A massive hurricane has devastated essential infrastructure, endangering 95% of our llamas. We can rebuild shelters, restore water supplies, and reinforce buildings. This immediate action will save lives.Grade - 5',
        },
        { name: 'X-Sender-Name', value: name },
      ],
      signer: createDataItemSigner(keyfile),
    });
    console.log(`messageId-${i} : `, msgId);
  }

  const walletAddress = await arweave.wallets.jwkToAddress(keyfile);
  console.log(`${walletAddress} : Sucess loop Finished!`);
  console.log('-------------------------------');
  console.log('-- await 3 seconds --');
  await new Promise(resolve => setTimeout(resolve, 3000));
  console.log('-- start next Loop --');
};
