#!/bin/bash

SCRIPT_NAME=`basename $0`
SCRIPT_DIR=`dirname "$PWD/$0"`

cd "$SCRIPT_DIR/.."

#
# parse the command-line arguments
#
FILE_LIST=()
REPO_LIST=()
while [[ $1 ]]; do
	case $1 in
	--help|-h|-\?)
		SHOW_HELP=1
		;;
	
 	--file|-f)
 		while [[ $2 ]]; do
 			case $2 in
 			-*)
 				break
 				;;
 				
 			*)
				FILE_LIST+=($2)
		 		shift
				;;	
 			esac
 		done
 		;;
	
 	--repo|-r)
 		REPOS_SPECIFIED=1
 		while [[ $2 ]]; do
 			case $2 in
 			-*)
 				break
 				;;
 				
 			*)
				REPO_LIST+=($2)
				shift
				;;	
 			esac
 		done
 		;;
 		
 	--commit|-c)
 		if [[ $2 ]]; then
 			COMMIT_MESSAGE=$2
 			shift
 		fi
 		;;
	
	*)
		exitWithErrorSuggestHelp "Unrecognized argument: $1"
		;;
	esac
	shift
done

showHelp()
{
	echo "$SCRIPT_NAME"
	echo
	printf "\tUses Boilerplate to generate one or more documents from boilerplate\n" 
	printf "\tfiles for one or more of the Cleanroom Project code repositories.\n"
	echo
	echo "Usage:"
	echo
	printf "\t$SCRIPT_NAME --file <file-list>\n"
	echo
	echo "Where:"
	echo
	printf "\t<file-list> is a space-separated list of the relative paths\n"
	printf "\t(within the target repos) of files to be generated.\n"
	echo
	echo "Optional arguments accepted:"
	echo
	printf "\t--repo <repo-list>\n"
	echo
	printf "\t\t<repo-list> is a space-separated list of the repos for which\n"
	printf "\t\tthe files will be generated. If this argument is not present,\n"
	printf "\t\tfile(s) will be regenerated for all known repos.\n"
	echo
	printf "\t--commit \"<message>\"\n"
	echo
	printf "\t\tIf this argument is specified, the script will attempt to.\n"
	printf "\t\tcommit changes using <message> as the commit message.\n"
	echo
	echo "Command-line flag aliases:"
	echo
	printf "\tShorthand aliases exist for all command-line flags:\n"
	echo
	printf "\t\t-f = --file\n"
	printf "\t\t-r = --repo\n"
	printf "\t\t-c = --commit\n"
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

isNotRepo()
{
	REPO_DIR="../../$1"
	if [[ ! -d "$REPO_DIR" ]]; then
		echo 1
	else
		pushd "$REPO_DIR" > /dev/null
		git status 2&> /dev/null
		RESULT=$?
		popd > /dev/null
		echo $RESULT
	fi
}

expectRepo()
{
	if [[ $(isNotRepo "$1") != 0 ]]; then
		REPO_PARENT="`cd ../..; pwd`"
		echo "error: Expected $1 (within the directory $REPO_PARENT) to be a git repo"
		exit 1
	fi
}

if [[ $SHOW_HELP ]]; then
	showHelp | less
	exit 1
fi

#
# if no repos were specified, use everything we have data for
#
if [[ ! $REPOS_SPECIFIED ]]; then
	for f in repos/*.xml; do
		REPO_LIST+=(`echo $f | sed "s/^repos\///" | sed "s/.xml$//"`)
	done
fi

if [[ ${#REPO_LIST[@]} < 1 ]]; then
	exitWithErrorSuggestHelp "At least one repo must be specified"
fi

#
# make sure everything we were handed looks like a real repo
#
for r in ${REPO_LIST[@]}; do
	expectRepo "$r"
done

#
# make sure boilerplate exists for each file specified
#
for f in ${FILE_LIST[@]}; do
	BOILERPLATE_FILE="boilerplate/$f.boilerplate"
	if [[ ! -f "$BOILERPLATE_FILE" ]]; then
		echo "error: Expected to find boilerplate file at $BOILERPLATE_FILE (within the directory $PWD)"
		exit 1
	fi
done

#
# process each file for each repo
#
for f in ${FILE_LIST[@]}; do
	BOILERPLATE_FILE="boilerplate/$f.boilerplate"

	echo "Generating $f..."
	for r in ${REPO_LIST[@]}; do
		printf "    ...for the $r repo"
		./bin/plate -t "$BOILERPLATE_FILE" -d repos/${r}.xml -m include/repos.xml -o "../../$r/$f"
		if [[ "$?" != 0 ]]; then
			exit 3
		fi
		printf " (done!)\n"
	done
done

#
# commit modified files, if we're supposed to
#
if [[ ! -z "$COMMIT_MESSAGE" ]]; then
	for r in ${REPO_LIST[@]}; do
		pushd "../../$r" > /dev/null
		echo "Committing $r"
		COMMIT_FILES=`printf " \"%s\"" ${FILE_LIST[@]}`
		git add$COMMIT_FILES
		git commit$COMMIT_FILES -m '$COMMIT_MESSAGE'
		popd > /dev/null
	done
fi
