module HelloWorld

import Package
import System
import Data.Vect

%access public export

-- Example of what a package definition would look like in Uwe

data OptLevel = O1 | O2 | O3

buildHelloWorld : OptLevel -> BuildOutputs
buildHelloWorld ol = do
    system "gcc -o main ~/code/hello_world/main.c"
    pure [(BinFile, "main")]

helloWorld : Package
helloWorld = MkPackage [] buildHelloWorld
