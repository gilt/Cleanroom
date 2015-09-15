#!/bin/bash

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd $PWD ; cd `dirname "$0"` ; echo $PWD)

cd "$SCRIPT_DIR/.."
source "bin/common-include.sh"

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
 		
 		
 	--all|-a)
		ALL_REPOS_FLAG=1
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
	echo "Required arguments:"
	echo
	printf "\t<file-list> is a space-separated list of the relative paths\n"
	printf "\t(within the target repos) of files to be generated.\n"
	echo
	printf "\t--repo <repo-list>\n"
	echo
	printf "\t\t<repo-list> is a space-separated list of the repos for which\n"
	printf "\t\tthe files will be generated. If this argument is not present,\n"
	printf "\t\tthe --all flag must be provided to force generation of all\n"
	printf "\t\tknown repos.\n"
	echo
	printf "\t--all\n"
	echo
	printf "\t\tThis argument is only required if --repo is not specified.\n"
	printf "\t\tWhen --all is specified, boilerplate regeneration will occur\n"
	printf "\t\tfor all known repos.\n"
	echo
	echo "Optional:"
	echo
	printf "\t--commit \"<message>\"\n"
	echo
	printf "\t\tIf this argument is specified, the script will attempt to\n"
	printf "\t\tcommit changes using <message> as the commit message.\n"
	echo
	echo "Command-line flag aliases:"
	echo
	printf "\tShorthand aliases exist for all command-line flags:\n"
	echo
	printf "\t\t-f = --file\n"
	printf "\t\t-r = --repo\n"
	printf "\t\t-a = --all\n"
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

if [[ $SHOW_HELP ]]; then
	showHelp | less
	exit 1
fi

if [[ ${#FILE_LIST[@]} < 1 ]]; then
	exitWithErrorSuggestHelp "At least one file must be specified"
fi

#
# if no repos were specified, require --all & use everything we have data for
#
if [[ $REPOS_SPECIFIED && $ALL_REPOS_FLAG ]]; then
	exitWithErrorSuggestHelp "--repo|-r and --all|-a are mutually exclusive; they may not both be specified at the same time"
fi
if [[ ! $REPOS_SPECIFIED ]]; then
	if [[ ! $ALL_REPOS_FLAG ]]; then
		exitWithErrorSuggestHelp "If no --repo|-r values were specified, --all|-a must be specified"
	fi

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
	expectRepo "../../$r"
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
