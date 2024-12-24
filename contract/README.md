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
        合约创建者->>+合约: 发布要拍卖的商品（商品名称，截止日期，商品的拍卖受益者）
        客户端->>+合约:第一次出价 hash(price)
        alt: 出价时间截止 
            合约->>+客户端: Error(出价时间截止)
        else: 出价时间未截止
            alt: 第一次出价:
                合约->>+合约: 存储出价的hash
            else: 出过了:
                合约->>+客户端: Error(你已经出过了)
            end    
        end
        note over 客户端,合约: 第一次出价截止，第二次出价开始    
        客户端 ->>+合约: 第二次出价(first bid hash, price)
        alt: 第一次出价时间截止且第二次未截止
            合约 ->>+ 客户端: 出价时间截止或者未开始
        else: 出价时间合适
            alt 第二次出过了:
                合约 ->>+ 合约: 你已经出过了
            else: 第二次没有出   
                合约 ->>+ 合约: 检查出价price和hash
                alt: hash value = hash(price) 且 hash = first hash
                    合约 ->>+ 合约: 存储用户的出价price和hash
                else: hash value != hash(price)
                    合约 ->>+ 客户端: 出的价格不正确
                end   
            end    
        end
        note over 客户端,合约: 第二次出价结束，合约开始进行校对
        合约 ->>+合约: 根据出价人的金额和hash作比较
        alt: 校验出价成功且为最高
            合约 ->>+ 商品主人合约地址: 出价的金额
        else: 校验不成功或者金额不是最高
            合约 ->>+ 客户端: 退回出价
        end
        
        
    
    