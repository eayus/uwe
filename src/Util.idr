module Util

import System
import Data.Hash

%access public export

fileCopy : String -> String -> IO ()
fileCopy src dst = do
    system $ "cp " ++ src ++ " " ++ dst
    pure ()

inTmpDir : IO a -> IO (String, a)
inTmpDir f = do
    dirname <- show . hash <$> time
    let filepath = "/tmp/" ++ dirname

    oldDir <- currentDir

    createDir filepath
    changeDir filepath
    
    res <- f

    changeDir oldDir
    pure (filepath, res)
