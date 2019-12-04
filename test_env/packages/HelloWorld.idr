module HelloWorld

import Package
import System
import Data.Vect

%access public export

-- Example of what a package definition would look like in Uwe

data OptLevel = O1 | O2 | O3

-- Currrent Build Function
buildHelloWorld : OptLevel -> BuildOutputs
buildHelloWorld _ = do
    system "gcc -o hello_world ~/code/hello_world/main.c"
    pure [(BinFile, "hello_world")]

HelloWorld : Package
HelloWorld = MkPackage "hello-world" [] O1 buildHelloWorld
