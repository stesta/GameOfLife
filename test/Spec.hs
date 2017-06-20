--------------------------------------------------------------------------------
import Test.Hspec
import GameOfHaskell.Core
import GameOfHaskell.Patterns
import Control.Monad.State
import Data.List

main :: IO ()
main = hspec $ do
  let game = evalState generations blinker

  describe "blinker" $ do 
    let phase1 board = (1, 0) `elem` board 
                    && (2, 0) `elem` board 
                    && (3, 0) `elem` board 
    let phase2 board = (2,-1) `elem` board 
                    && (2, 0) `elem` board 
                    && (2, 1) `elem` board 
    
    it "generation 0" $ do 
      phase1 (game!!0) `shouldBe` True
      phase2 (game!!0) `shouldBe` False
    
    it "generation 1" $ do
      phase1 (game!!1) `shouldBe` False  
      phase2 (game!!1) `shouldBe` True

    it "generation 2" $ do
      phase1 (game!!2) `shouldBe` True  
      phase2 (game!!2) `shouldBe` False
