module PackageDatabase


import Package

-- All our package imports
import HelloWorld


%access public export


packages : PackageCollection
packages = [ HelloWorld ]
