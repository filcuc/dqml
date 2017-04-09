# DQML
[![Build Status](https://travis-ci.org/filcuc/dqml.svg?branch=master)](https://travis-ci.org/filcuc/DQml)

QML binding for the D programming language

# Supported features
* Creation of custom QObjects
* Creation of custom QAbstractItemModels
* Creation of QML instantiable QObjects
* Creation of QML instantiable Singleton

# Requirements
* Install the [DOtherSide](https://github.com/filcuc/DOtherSide) library 0.6.0 or higher
* Install [dmd](http://dlang.org/download.html#dmd) 2.071 or higher

## Buildinstructions
### Linux
* Compile and Install DOtherside in your system PATH (i.e. /usr/lib)
* dub fetch dqml

### Windows
Due to the shitty linker used by DMD (optlink) on windows.
Using this bindings it's a little bit more complicated on this platform.
Basically the hard part consists in generating a valid .lib for the DOtherSide.dll.
I wrote a step by step tutorial, that you can read [here](https://github.com/filcuc/dqml/blob/master/WindowsUsage.md);
