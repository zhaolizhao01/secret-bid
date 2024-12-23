# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```


# 时序图Mermaid

    sequenceDiagram
    合约创建者->>+合约: 发布要拍卖的商品（商品名称，截至日期）
    客户端->>+合约:出价 hash(price)
    alt: 出价时间截止
        合约->>+客户端: 返回403, 出价时间截止
    else: 出价时间未截止
        合约->>+合约: 存储出价的hash
    end
    note over 客户端,合约: 出价截至，出价人现在开始<br>把自己出价的金额转到合约    
    客户端 ->>+合约: 出价hash(price)和price
    alt: 出价时间截止
        合约 ->>+ 客户端: 返回403，出价时间截止
    else: 出价时间未截止
        合约 ->>+ 合约: 检查出价price和hash
        alt: hash value = hash(price)
            合约 ->>+ 合约: 存储用户的出价price和hash
        else: hash value != hash(price)
            合约 ->>+ 客户端: 返回400
        end
    end
    note over 客户端,合约: 校验截至, 合约开始进行校对
    合约 ->>+合约: 根据出价人的金额和hash作比较
    alt: 校验出价成功且为最高
        合约 ->>+ 商品主人合约地址: 出价的金额
    else: 校验不成功或者金额不是最高
        合约 ->>+ 客户端: 退回出价
    end
    