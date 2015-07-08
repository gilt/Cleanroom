#!/bin/bash

SCRIPT_NAME=`basename $0`
SCRIPT_DIR=`dirname "$PWD/$0"`
PLATE_BIN="$SCRIPT_DIR/plate"
DEST_ROOT="$SCRIPT_DIR/../../.."

#
# parse the command-line arguments
#
while [[ $1 ]]; do
	case $1 in
	--help|-h|-\?)
		SHOW_HELP=1
		;;
	
	--force|-f)
		FORCE_MODE=1
		;;
		
	--dest|-d)
 		while [[ $2 ]]; do
 			case $2 in
 			-*)
 				break
 				;;
 				
 			*)
 				if [[ ${2:0:1} == '/' ]]; then
					DEST_ROOT="$2"
				else
					DEST_ROOT="$PWD/$2"
 				fi
		 		shift
				;;	
 			esac
 		done
		;;
	
	--owner|-o)
 		while [[ $2 ]]; do
 			case $2 in
 			-*)
 				break
 				;;
 				
 			*)
				REPO_OWNER="$2"
		 		shift
				;;	
 			esac
 		done
 		;;
	
 	--platform|-p)
 		while [[ $2 ]]; do
 			case $2 in
 			-*)
 				break
 				;;
 				
 			*)
				PLATFORM="$2"
		 		shift
				;;	
 			esac
 		done
 		;;
	
	*)
		if [[ -z "$NEW_REPO_NAME" ]]; then
			NEW_REPO_NAME="$1"
		else
			exitWithErrorSuggestHelp "Unrecognized argument: $1"
		fi
		;;
	esac
	shift
done

showHelp()
{
	echo "$SCRIPT_NAME"
	echo
	printf "\tCreates a skeleton Xcode project structure with common build settings.\n" 
	printf "\tThe directory will be placed parallel to that of the Cleanroom repo,\n"
	printf "\tand will be initialized as a git repo.\n"
	echo
	echo "Usage:"
	echo
	printf "\t$SCRIPT_NAME <project-name> (--owner|-o) <github-user-id>\n"
	echo
	echo "Where:"
	echo
	printf "\t<project-name> is the name of the project to create.\n"
	echo
	echo "Required arguments:"
	echo
	printf "\t<github-user-id> is the GitHub user ID of the repo's owner.\n"
	echo
	echo "Optional arguments accepted:"
	echo
	printf "\t--dest <destination-dir>\n"
	echo
	printf "\t\tThe --dest (or -d) argument accepts a filesystem path\n"
	printf "\t\tspecifying the directory in which the project repo will\n"
	printf "\t\tbe created. If not specified, the new repo will be created\n"
	printf "\t\tin the parent directory of the repo in which this script lives.\n"
	echo
	printf "\t--platform (iOS|OSX)\n"
	echo
	printf "\t\tThe --platform (or -p) argument accepts a single platform\n"
	printf "\t\tspecifier (either 'iOS' or 'OSX'); the resulting Xcode project\n"
	printf "\t\twill be specific to that platform.\n"
	echo
	printf "\t--force\n"
	echo
	printf "\t\tBy default, the script will not run if the destination directory\n"
	printf "\t\talready contains a file named <project-name>. Using --force (or\n"
	printf "\t\t-f) overrides this check, allowing the script to proceed.\n"
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

executeCommand()
{
	eval "$@"
	if [[ $? != 0 ]]; then
		exitWithError "Command failed"
	fi
}

if [[ $SHOW_HELP ]]; then
	showHelp | less
	exit 1
fi

DEST_ROOT=$( cd "$DEST_ROOT"; echo $PWD )
if [[ ! -d "$DEST_ROOT" ]]; then
	exitWithErrorSuggestHelp "Couldn't find destination directory: $DEST_ROOT"
fi

if [[ -e "$DEST_ROOT/$NEW_REPO_NAME" && $FORCE_MODE != 1 ]]; then
	exitWithErrorSuggestHelp "Directory already exists: $DEST_ROOT/$NEW_REPO_NAME" "Use --force (or -f) to override"
fi

if [[ -z "$REPO_OWNER" ]]; then
	exitWithErrorSuggestHelp "The repo's owner must be specified"
fi

if [[ -z "$NEW_REPO_NAME" ]]; then
	exitWithErrorSuggestHelp "At least one repo must be specified"
fi

if [[ ! -z "$PLATFORM" ]]; then
	exitWithErrorSuggestHelp "The --platform (-p) argument is not yet implemented"
fi

processDirectory()
{
	pushd "$1" > /dev/null
	for f in *; do
		DEST_NAME=$( echo "$f" | sed "s/CleanroomSkeleton/${NEW_REPO_NAME}/" )
		if [[ $( echo "$f" | grep -c "^_" ) > 0 ]]; then
			DEST_NAME=$( echo "$f" | sed "s/^_/./" )
		fi
		
		if [[ ! -z "$2" ]]; then
			DEST_DIR="$2/"
		fi
		
		if [[ -d "$f" ]]; then
			printf "\t${DEST_ROOT}/${DEST_DIR}. <- ${DEST_NAME}/\n"
			executeCommand "mkdir -p \"${DEST_ROOT}/${DEST_DIR}${DEST_NAME}\""
			processDirectory "$f" "${DEST_DIR}${DEST_NAME}"
		elif [[ $( echo "$f" | grep -c "\.boilerplate\$" ) > 0 ]]; then
			DEST_NAME=$( echo "$DEST_NAME" | sed "s/\.boilerplate\$//" )
				printf "\t${DEST_ROOT}/${DEST_DIR}${DEST_NAME} <- $f\n"
			CREATOR_USER=`id -un`
			CREATOR_NAME=`id -F`
			$PLATE_BIN -t "$f" -o "${DEST_ROOT}/${DEST_DIR}${DEST_NAME}" -m ../include/repos.xml --stdin-data <<MBML_BLOCK
<MBML>
	<Var name="repo:owner" literal="${REPO_OWNER}"/>
	<Var name="project:name" literal="${NEW_REPO_NAME}"/>
	<Var name="project:creator:name" literal="${CREATOR_NAME}"/>
	<Var name="project:creator:id" literal="${CREATOR_USER}"/>
</MBML>
MBML_BLOCK
		else
			if [[ "$f" == "$DEST_NAME" ]]; then
				printf "\t${DEST_ROOT}/${DEST_DIR}. <- $f\n"
			else
				printf "\t${DEST_ROOT}/${DEST_DIR}${DEST_NAME} <- $f\n"
			fi
			executeCommand "cp \"$f\" \"${DEST_ROOT}/${DEST_DIR}${DEST_NAME}\""
		fi
	done
	popd > /dev/null
}

cd "$SCRIPT_DIR/../skeletons"

echo "Creating new Xcode framework project repo $NEW_REPO_NAME in $DEST_ROOT"
processDirectory "framework"

cd "$DEST_ROOT/$NEW_REPO_NAME"
git init
echo "Done!"
