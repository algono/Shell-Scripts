#!/bin/sh

TMP="/tmp/spin"
SEP="+"
SRC="source.pml"

copyToTmp() 
{
    mkdir -p "$TMP"
    cp "$1" "$TMP/$SRC"
    cd "$TMP" || exit
}

generate() 
{
    echo "Generating file..."
    spin -a $SRC "$@"
}

compile() 
{
    echo "Compiling..."
    gcc -o pan pan.c
}

runPan() 
{
    echo "Running..."
    ./pan "$@"
}

run() 
{
    copyToTmp "$1"
    shift

    spinArgs="$(echo "$@" | cut -d "$SEP" -f1)"
    panArgs="$(echo "$@" | cut -d "$SEP" -f2)"
	
    echo "Spin args : $spinArgs"
    echo "Pan args : $panArgs"

    generate "$spinArgs"
    compile
    runPan "$panArgs"
}

clean() 
{
    echo "Cleaning..."
    rm -r "$TMP"
}

trace() 
{
    cd "$TMP" || exit
    spin -t -p $SRC "$@"
}

fspin_help()
{
    echo "Usage: fspin <mode> ..."
    echo "Utility command for spin/promela, automating some long and repetitive tasks."
    echo ""
    echo "Modes:"
    echo "-r, --run       Runs the specified file with any provided arguments."
    echo "-c, --clean         Cleans any temp files from previous runs."
    echo "-rc, --run-clean        Equal to run mode, but cleans temp files after."
    echo "-t, --trace         Show the trace file for the last script run."
    echo ""
    echo "Full syntax for some modes:"
    echo "Run or Run-clean mode: fspin <mode> <file> [<spin-args> '+' <pan-args>]"
    echo "Trace mode: fspin --trace <spec> [<extra-args>]"
    exit 0
}

if [ "$#" -lt 1 ]; then
    echo "Usage: fspin <mode> [--help for more details]." >&2
    exit 1
fi

MODE="$1"
shift

if [ "$MODE" = "--help" ]; then
    fspin_help
elif [ "$MODE" = "-r" ] || [ "$MODE" = "--run" ]; then
    run "$@"
elif [ "$MODE" = "-c" ] || [ "$MODE" = "--clean" ]; then
    clean
elif [ "$MODE" = "-rc" ] || [ "$MODE" = "--run-clean" ]; then
    run "$@"
    clean
elif [ "$MODE" = "-t" ] || [ "$MODE" = "--trace" ]; then
    trace "$@"
fi
