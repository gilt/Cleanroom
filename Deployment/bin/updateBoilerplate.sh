#!/bin/bash

SCRIPT_NAME=`basename $0`
SCRIPT_DIR=`dirname "$PWD/$0"`
BOILERPLATE_DIR="$SCRIPT_DIR/../boilerplate"
BOILERMAKER_ARGS="$@"

processBoilerplateFile()
{
	BASE_FILENAME=`echo "$1" | sed s#.boilerplate##`
	pushd "$SCRIPT_DIR" > /dev/null
	./boilermaker.sh $BOILERMAKER_ARGS --file "$BASE_FILENAME"
	EXIT_CODE=$?
	if [[ $EXIT_CODE != 0 ]]; then
		exit $EXIT_CODE
	fi
	popd > /dev/null
}

processSubpath()
{
	cd "$BOILERPLATE_DIR/$1"
	
	for f in *; do
		if [[ -d "$f" ]]; then
			processSubpath "$1/$f"
		elif [[ $(echo "$f" | grep -c "\.boilerplate\$") > 0 ]]; then
			processBoilerplateFile "$1/$f"
		fi
	done
}

processSubpath .

