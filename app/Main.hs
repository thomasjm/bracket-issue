module Main where

import Control.Concurrent
import Control.Exception
import System.Process

main :: IO ()
main = do
  bracket (callProcess "docker" ["run", "-d", "--name", "container1", "registry:2"])
          (\() -> do
              putStrLn "Outer release"
              callProcess "docker" ["rm", "-f", "container1"]
              putStrLn "Done with outer release"
          )
          (\() -> do
             bracket (callProcess "docker" ["run", "-d", "--name", "container2", "registry:2"])
                     (\() -> do
                         putStrLn "Inner release"
                         callProcess "docker" ["rm", "-f", "container2"]
                         putStrLn "Done with inner release"
                     )
                     (\() -> do
                         putStrLn "Inside both brackets, sleeping!"
                         threadDelay 300000000
                     )
          )
