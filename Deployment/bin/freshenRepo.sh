#!/bin/bash

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd $PWD ; cd `dirname "$0"` ; echo $PWD)

cd "$SCRIPT_DIR"
source common-include.sh

BOILERPLATE_DIR="$SCRIPT_DIR/../boilerplate"
BOILERMAKER_ARGS="$@"

processBoilerplateFile()
{
	pushd "$SCRIPT_DIR" > /dev/null

	BASE_FILENAME=`echo "$1" | sed s#.boilerplate##`
	executeCommand "./boilermaker.sh $BOILERMAKER_ARGS --file \"$BASE_FILENAME\""

	popd > /dev/null
}

processStandardFile()
{
	pushd "$SCRIPT_DIR" > /dev/null

	executeCommand "./copyToCleanroomRepos.sh \"$1\" $BOILERMAKER_ARGS"

	popd > /dev/null
}

processSubpath()
{
	pushd "$BOILERPLATE_DIR/$1" > /dev/null
	
	for f in *; do
		if [[ -d "$f" ]]; then
			processSubpath "$1/$f"
		elif [[ $(echo "$f" | grep -c "\.boilerplate\$") > 0 ]]; then
			processBoilerplateFile "$1/$f"
		else
			processStandardFile "$1/$f"
		fi
	done

	popd > /dev/null
}

processSubpath .

