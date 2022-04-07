#  MetaBlo.cc - Open Source NFT renting protocol

## Table of Contents
+ [How it works](#how)
+ [Getting Started](#getting_started)
+ [Usage](#usage)
+ [Contributing](../CONTRIBUTING.md)

## How it works <a name = "how"></a>
Actors: Proprietor (P), Tenant (T), Market Maker (MM)

1. When P wants to list an NFT on the rental market, P calls the `stake()` function with tokenID and collection address as parameters.
2. `stake()` will mint a new ERC721 with certain important attribuets regarding original NFT stored on-chain.
3. User (P0 can then list this ERC721 on the rental market by calling the `list()` function.
4. Tenants (T) can now buy this proof of NFT by calling the `buy()` function. 
4. a) They need to submit a deposit, and create a vault using the `createVault()` function. This is where the monthly withdrawal happens from. Upon defaulting, the collateral is submitted to the Propreitor (P). 
5. 

## Getting Started <a name = "getting_started"></a>
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them.

```
Give examples
```

End with an example of getting some data out of the system or using it for a little demo.

## Contributing <a name="contributing">

