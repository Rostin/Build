#!/usr/bin/env bash


function build () {
        pushd .
        TYPE=$1
        DIR="build/"$1_$2
        BIN=`pwd`"/"$DIR"/bin"
        mkdir -p $DIR
        cd $DIR
        cmake ../.. -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE=${BIN} \
                    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${BIN} \
                    -DCMAKE_BUILD_TYPE=${TYPE^} \
                    -DCMAKE_CXX_COMPILER="$2" \
                    -DCMAKE_CXX_FLAGS="-Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic -Wold-style-cast -Wcast-align -Woverloaded-virtual -Wpedantic -Wconversion -Wsign-conversion"
        make all
        popd
        linker "$DIR"
}

function buildall(){
        build "debug" "g++"
        build "release" "g++"
        build "debug" "clang++"
        build "release" "clang++"
}

function linker(){
        if [ -L $1/bin/resources ]
        then
                exit
        fi
        FOLDER=`pwd`
        ln -s $FOLDER/resources $FOLDER/$1/bin/resources
}


if [ "$1" == "" ]
then
        echo "Available commands: 
        clean - Removes all build files and generates new ones for all 4 environmnts 
        all - Builds for all 4 environemnts
        debug - Creates a debug build using g++
        release - Creates a release build using g++
        debug clang - Creates a debug build using clang++
        release clang - Creates a release build using clang ++
        All of the commands will create a soft link for the resources folder into the bin directories."
        exit
fi



if [ "$1" == "clean" ]
then 
    rm -rf ./build
    buildall

elif [ "$1" == "all" ]
then
    buildall

elif [ "$1" == "debug" ]
then
    COMPILER="g++"
    if [ "$2" == "clang" ]
    then
            COMPILER="clang++"
    fi
    build "$1" "$COMPILER" 

elif [ "$1" == "release" ]
then
    COMPILER="g++"
    if [ "$2" == "clang" ]
    then
            COMPILER="clang++"
    fi
    build "$1" "$COMPILER"
fi
