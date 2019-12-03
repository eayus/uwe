module Main

import Package
import HelloWorld
import Data.HVect

myHelloWorld : PackageInstance HelloWorld.helloWorld
myHelloWorld = MkPackageInstance O2 []

myEnv : Environment
myEnv = [(HelloWorld.helloWorld ** myHelloWorld)]

main : IO ()
main = do
    s <- withEnv myEnv
    putStrLn s
    pure ()
