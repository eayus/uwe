module Pkg

import Data.Vect
import Data.HVect
import Data.Hash
import System
import Util

%access public export

FilePath : Type
FilePath = String

data FileType = BinFile | LibFile

OutFile : Type
OutFile = (FileType, FilePath)

fileTypePrefix : FileType -> String
fileTypePrefix BinFile = "bin/"
fileTypePrefix LibFile = "lib/"

BuildOutputs : Type
BuildOutputs = IO (List OutFile)


data Package : Type where
    MkPackage : {options : Type}
             -> (deps : Vect n Package)
             -> (build : options -> BuildOutputs)
             -> Package


optionsFor : Package -> Type
optionsFor (MkPackage {options} _ _ ) = options

mutual
    depsFor : Package -> Type
    depsFor (MkPackage deps _) = HVect (map PackageInstance deps)

    data PackageInstance : Package -> Type where
        MkPackageInstance : {pkg : Package} -> optionsFor pkg -> depsFor pkg -> PackageInstance pkg


Environment : Type
Environment = List (pkg : Package ** PackageInstance pkg)


{--withEnv : Environment -> IO a -> IO a
withEnv = ?todolater--}



-- HASHING

{--hashInputs : HVect xs -> a -> IO String
hashInputs _ _ = show $ (hashDeps--}

-- returns installed location
installPkg : PackageInstance pkg -> IO FilePath
installPkg (MkPackageInstance {pkg} opts deps) = let (MkPackage _ build) = pkg in do
    (buildFolder, outFiles) <- inTmpDir $ build opts
    folderName <- show . hash <$> time

    let outdir = "~/ellis/code/uwe/test_env/store/" ++ folderName ++ "/"

    createDir outdir
    changeDir outdir
    createDir "bin"
    createDir "lib"

    let f = \tup => do
        let type = fst tup
        let name = snd tup
        let src = buildFolder ++ "/" ++ name
        let dst = outdir ++ fileTypePrefix type
        fileCopy src dst

    traverse f outFiles

    pure outdir


withEnv : Environment -> IO String
withEnv e = do
    let f = \(_ ** p) => installPkg p
    folders <- traverse f e
    let path = pack $ map (\c => if c == ' ' then ':' else c) $ unpack $ unwords $ map (++ "bin/") folders
    let libPath = pack $ map (\c => if c == ' ' then ':' else c) $ unpack $ unwords $ map (++ "lib/") folders
    let pathExport = "export PATH=" ++ path
    let libExport = "export LD_LIBRARY_PATH=" ++ libPath
    pure $ pathExport ++ ";" ++ libExport

