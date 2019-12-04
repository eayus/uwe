module Main

import Package
import PackageDatabase
import HelloWorld
import Data.HVect
import System

myHelloWorld : PackageInstance HelloWorld
myHelloWorld = defaultPackageInstance HelloWorld --MkPackageInstance O2 []

myEnv : Environment
myEnv = [(HelloWorld ** myHelloWorld)]


uweShell : Environment -> IO ()
uweShell e = do
    s <- withEnv e
    system s
    pure ()


lookupPkg : String -> Maybe Package
lookupPkg name = find (\(MkPackage pkgName _ _ _) => name == pkgName) packages

lookupPkgInstance : String -> Maybe (pkg : Package ** PackageInstance pkg)
lookupPkgInstance s = (\p => (p ** defaultPackageInstance p)) <$> lookupPkg s

main : IO ()
main = do
    (_ :: packageNames) <- getArgs

    case traverse lookupPkgInstance packageNames of
        Just e => uweShell e
        Nothing => putStrLn "Unknown package"
