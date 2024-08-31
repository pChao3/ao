

world = "lA4WPP5v9iUowzLJtCjZsSH_m6WV2FUbGlPSlG7KbnM"
llama  ="pazXumQI-HPH7iFGfTC-4_7biSnqz_U67oFAGry5zUY"
Game='sZe_mf4uJs1khzh0QZmNnaxdoXtBa51LRh2uhnDyk3Y'
fishman = 'M7njeaA88ynBogxsjQsyrT2Y_G51hcru1Kil4f0u8gg'
fishRod = 'gm9hLIm3kyWw_Itt1Ub494lFStZoUbOAeZreDfOR2t8' 
commonFish = "BC4KnHcT4YnonwToJATLabIJRGIYdYxY2-KnHbe1tN0"
rareFish = "HsR53ViqEyHMyAdv5Utz8fV_QRlmpMcaP4Py0R2ZgRM"
legendFish = "ENNFBJS_TpBTh-xR648Pdpx2Z8YgZkRbiqbuzfVv0M4"

flag = false

-- // pay
Handlers.add(
  'StartInteraction', 
  function (msg)
    return msg.Action == "StartInteraction" 
  end,
  function (msg)
    print('pay...')
    flag = true
        ao.send({ Target = llama,Action = "Transfer",Recipient = Game,Quantity = "10000000000000",["X-Sender-Name"]="dum",["X-Note"]="Enroll"})
  end
)


-- // start
Handlers.add(
  'Debit-Notice', 
  function (msg)
    return msg.Action == "Debit-Notice" 
  end,
  function (msg)
    if flag then
      flag = false
      for i=1,10 do 
        print(i)  
        ao.send({Target=fishRod, Action = "DefaultInteraction"})
        if i == 10 then
          ao.send({Target=ao.id, Action = "StartInteraction"})
          return
        end
      end
    end
  end
)

-- // sell
Handlers.add(
  'TransErr', 
  function (msg)
    return msg.Action == "Transfer-Error" 
  end,
  function (msg)
    print(msg.Error)
  end
)

Handlers.add(
  'SellFish', 
  function (msg)
    return msg.Action == "Sell" 
  end,
  function (msg)
    flag = false
    if msg.Data1 then
      ao.send({Target=commonFish, Action="Transfer",Quantity=msg.Data1, Recipient=Game})
    end
    if msg.Data2 then
      ao.send({Target=rareFish, Action="Transfer",Quantity=msg.Data2, Recipient=Game})
    end
    if msg.Data3 then
      ao.send({Target=legendFish, Action="Transfer",Quantity=msg.Data3, Recipient=Game})
    end
  end
)