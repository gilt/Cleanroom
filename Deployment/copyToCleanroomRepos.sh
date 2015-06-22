#!/bin/bash

SCRIPT_NAME=`basename $0`
SCRIPT_DIR=`dirname "$PWD/$0"`

cd "$SCRIPT_DIR/.."
REPO_DIR="$PWD"
REPO_NAME=`basename "$PWD"`
cd ..
EXEC_DIR="$PWD"

isNotRepo()
{
	pushd "$1" > /dev/null
	git status 2&> /dev/null
	RESULT=$?
	popd > /dev/null
	echo $RESULT
}

#
# find the individual Cleanroom Project repos
#
REPO_LIST=()
for f in *; do
	if [[ -d "$f" ]] && [[ $f != "$REPO_NAME" ]] && [[ $f == "Cleanroom"* ]]; then
		if [[ $(isNotRepo "$f") == 0 ]]; then
			REPO_LIST+=("$f")
		fi
	fi
done

showHelp()
{
	echo "$SCRIPT_NAME"
	echo
	printf "\tCopies one or more portions of the Cleanroom master repo\n"
	printf "\tinto one or more parallel Cleanroom Project code repos.\n"
	echo
	echo "Usage:"
	echo
	printf "\t$SCRIPT_NAME <relative-path> [<relative-path> [...]]\n"
	echo
	echo "Where:"
	echo
	printf "\t<relative-path> is the relative path of a file or directory\n"
	printf "\twithin the instance of the Cleanroom master repository at:\n"
	echo
	printf "\t\t$REPO_DIR\n"
	echo
	printf "\tEach <relative-path> is recursively copied to the appropriate\n"
	printf "\tlocation in the individual Cleanroom Project repos that exist\n"
	printf "\tparallel to $REPO_NAME within the directory:\n"
	echo
	printf "\t\t$EXEC_DIR\n"
	echo
	printf "\tThe following Cleanroom Project repos have been detected within\n"
	printf "\tthe directory above:\n"
	echo
	printf "\t\t%s\n" ${REPO_LIST[@]}
	echo
	echo "Help"
	echo
	printf "\tThis documentation is displayed when supplying the --help (or\n"
	printf "\t-h or -?) argument.\n"
	echo
	printf "\tNote that when this script displays help documentation, all other\n"
	printf "\tcommand line arguments are ignored and no other actions are performed.\n"
	echo
}

printError()
{
	echo "error: $1"
	echo
	if [[ ! -z $2 ]]; then
		printf "  $2\n\n"
	fi
}

exitWithError()
{
	printError "$1" "$2"
	exit 1
}

exitWithErrorSuggestHelp()
{
	printError "$1" "$2"
	printf "  To display help, run:\n\n\t$0 --help\n"
	exit 1
}

confirmationPrompt()
{
	echo
	printf "$1\n"
	echo
	read -p "Are you sure you want to continue? " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		exit -1
	fi
}

expectRepo()
{
	if [[ $(isNotRepo "$1") != 0 ]]; then
		echo "error: Expected $1 (within the directory $PWD) to be a git repo"
		exit 1
	fi
}

executeCommand()
{
	eval "$1"
	if [[ $? != 0 ]]; then
		exitWithError "Command failed"
	fi
}

#
# parse the command-line arguments
#
ARGS=()
while [[ $1 ]]; do
	case $1 in
	--help|-h|-\?)
		SHOW_HELP=1
		;;
	
	--force|-f)
		FORCE_MODE=1
		;;
	
	-*)
		exitWithErrorSuggestHelp "Unrecognized argument: $1"
		;;
		
	*)
		ARGS+=($1)
		;;
	esac
	shift
done

if [[ $SHOW_HELP ]]; then
	showHelp
	exit 1
fi

#
# do some sanity checking on the execution environment
#
if [[ ${#REPO_LIST[@]} < 1 ]]; then
	exitWithErrorSuggestHelp "Expecting to find at least one Cleanroom Project repo within $EXEC_DIR"
fi

expectRepo "$REPO_NAME"
if [[ "$REPO_NAME" != "Cleanroom" ]]; then
	confirmationPrompt "WARNING: This script is expected to run within a repo named Cleanroom.\n\nInstead, this script is being run from within $REPO_NAME."
fi

#
# ensure that the arguments are all things that can be copied
#
for f in ${ARGS[@]}; do
	ITEM=`basename $f`
	DIR=`dirname $f`
	if [[ $DIR == '.' ]]; then
		DIR=""
	else
		DIR="$DIR/"
	fi
	if [[ $FORCE_MODE ]]; then
		CP_ARGS="f"
	else
		CP_ARGS="i"
	fi
	for r in ${REPO_LIST[@]}; do
		echo "Copying $ITEM to $r/$DIR."
		executeCommand "cp -${CP_ARGS}R \"${REPO_NAME}/${DIR}${ITEM}\" \"$r/$DIR.\""
	done
done
