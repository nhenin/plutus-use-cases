{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Common.Api where

import Data.Aeson
import Data.Aeson.GADT.TH
import Data.Constraint.Extras.TH
import Data.GADT.Compare.TH
import Data.GADT.Show.TH
import Data.Semigroup (First(..))
import Data.Text (Text)
import Data.Vessel

import Common.Plutus.Contracts.Uniswap.Types
import Common.Schema

commonStuff :: String
commonStuff = "Here is a string defined in Common.Api"

type DexV = Vessel Q

-- Note: This is view
data Q (v :: (* -> *) -> *) where
  Q_ContractList :: Q (IdentityV (First (Maybe [Text])))
  Q_PooledTokens :: Q (IdentityV (First (Maybe [PooledToken])))

data Api :: * -> * where
  -- TODO: Coin and Amount will eventually be imported from plutus itself.
  -- Once GHC 8.10 is supported in Obelisk, we will be able to reference
  -- plutus ADTs directly. For now, they will come from Common.Plutus.Contracts.Uniswap.Types
  Api_Swap :: ContractInstanceId Text -> Coin AssetClass -> Coin AssetClass -> Amount Integer -> Amount Integer -> Api (Either String [Text])
  Api_Stake :: ContractInstanceId Text -> Coin AssetClass -> Coin AssetClass -> Amount Integer -> Amount Integer -> Api (Either String [Text])
  Api_RedeemLiquidity :: ContractInstanceId Text -> Coin AssetClass -> Coin AssetClass -> Amount Integer -> Api (Either String [Text])
  Api_CallFunds :: ContractInstanceId Text -> Api ()
  Api_CallPools :: ContractInstanceId Text -> Api ()

deriveJSONGADT ''Api
deriveArgDict ''Api

deriveArgDict ''Q
deriveJSONGADT ''Q
deriveGEq ''Q
deriveGCompare ''Q
deriveGShow ''Q
