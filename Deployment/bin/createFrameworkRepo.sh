#!/bin/bash

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd "$PWD" ; cd `dirname "$0"` ; echo "$PWD")

cd "$SCRIPT_DIR"
source common-include.sh

PLATE_BIN="$SCRIPT_DIR/plate"
DEST_ROOT="$SCRIPT_DIR/../../.."
DEFAULT_DEST_ROOT=$( cd "$DEST_ROOT"; echo $PWD )
POSSIBLE_PLATFORMS=( iOS macOS tvOS watchOS all )
REAL_PLATFORMS=${POSSIBLE_PLATFORMS[@]:0:${#POSSIBLE_PLATFORMS[@]}-1}
POSSIBLE_PLATFORMS_STR=`echo -n "${POSSIBLE_PLATFORMS[@]}"`
POSSIBLE_PLATFORMS_PARAM=`echo $POSSIBLE_PLATFORMS_STR | sed 's/ /|/g'`
REPO_BRANCH=master

#
# parse the command-line arguments
#
PLATFORMS=()
while [[ $1 ]]; do
	case $1 in
	--help|-h|-\?)
		SHOW_HELP=1
		;;
	
	--force|-f)
		FORCE_ARG="$1"
		FORCE_MODE=1
		;;
	
	--branch|-b)
		while [[ $2 ]]; do
 			case $2 in
 			-*)
 				break
 				;;
 				
 			*)
				REPO_BRANCH="$2"
		 		shift
				;;	
 			esac
 		done
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
 			
 			all)
 				PLATFORMS=(${PLATFORMS[@]} ${REAL_PLATFORMS[@]})
 				shift
 				;;
 				
 			*)
				PLATFORMS+=($2)
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
	printf "\tCreates a skeleton Xcode project structure with standard build settings\n" 
	printf "\tideal for creating a Swift dynamic framework.\n"
	echo
	printf "\tWith this script, you can be up and running building cross-platform\n"
	printf "\tSwift dynamic frameworks in no time. Just write your code and go.\n"
	echo
	printf "\tThe script creates a new directory <project-name> inside the\n"
	printf "\t<destination-dir> and populates it with an Xcode project file\n"
	printf "\tcontaining one or more framework build targets (one for each\n"
	printf "\tplatform to be supported) and stub code.\n"
	echo
	printf "\tOnce the project directory has been created, it will then be\n"
	printf "\tinitialized as a git repo.\n"
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
	echo "Optional arguments:"
	echo
	printf "\t--dest <destination-dir>\n"
	echo
	printf "\t\tThe --dest (or -d) argument accepts a filesystem path\n"
	printf "\t\tspecifying the directory in which the project repo will\n"
	printf "\t\tbe created.\n"
	echo
	printf "\t\tIf this argument is not provided, newly-created repos will\n"
	printf "\t\tbe placed within:\n"
	echo
	printf "\t\t\t${DEFAULT_DEST_ROOT}\n"
	echo
	printf "\t--platform ($POSSIBLE_PLATFORMS_PARAM)\n"
	echo
	printf "\t\tThe --platform (or -p) argument accepts a platform specifier\n"
	printf "\t\tthat governs which platform(s) will be supported by the project\n"
	printf "\t\tfile to be created. The value 'all' specifies all supported\n"
	printf "\t\tplatforms. If no value for the --platform argument is provided,\n"
	printf "\t\t'all' is assumed; let's be cross-platform by default!\n"
	echo
	printf "\t--force\n"
	echo
	printf "\t\tBy default, the script won't run if the destination directory\n"
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

if [[ $SHOW_HELP ]]; then
	showHelp
	exit 1
fi

REPO_BRANCH_ARG="--branch $REPO_BRANCH"

if [[ -z "$NEW_REPO_NAME" ]]; then
	exitWithErrorSuggestHelp "Must provide name of new repo/project"
fi

DEST_ROOT=$( cd "$DEST_ROOT"; echo $PWD )
if [[ ! -d "$DEST_ROOT" ]]; then
	exitWithErrorSuggestHelp "Couldn't find destination directory: $DEST_ROOT"
fi

if [[ -e "$DEST_ROOT/$NEW_REPO_NAME" && $FORCE_MODE != 1 ]]; then
	exitWithErrorSuggestHelp "Directory already exists: $DEST_ROOT/$NEW_REPO_NAME" "Use --force (or -f) to override"
fi

REPO_SETTINGS_FILE="$SCRIPT_DIR/../repos/${NEW_REPO_NAME}.xml"
if [[ -z "$REPO_OWNER" && ! -r "$REPO_SETTINGS_FILE" ]]; then
	exitWithErrorSuggestHelp "The repo's owner must be specified"
fi

if [[ ${#PLATFORMS[@]} == 0 ]]; then
	PLATFORMS=(${REAL_PLATFORMS[@]})
fi

INCLUDE_IOS=0
INCLUDE_MACOS=0
INCLUDE_TVOS=0
INCLUDE_WATCHOS=0
for p in "${PLATFORMS[@]}"; do
	isInArray "$p" ${REAL_PLATFORMS[@]}
	if [[ $? == 0 ]]; then
		exitWithErrorSuggestHelp "The value \"$p\" passed to the --platform (-p) argument is not recognized" "Accepted values: $POSSIBLE_PLATFORMS_STR"
	fi

	case $p in
	iOS)
		INCLUDE_IOS=1
		PLATFORM_MBML="$PLATFORM_MBML<Var literal=\"iOS\"/>"
		;;
		
	macOS)
		INCLUDE_MACOS=1
		PLATFORM_MBML="$PLATFORM_MBML<Var literal=\"macOS\"/>"
		;;
		
	tvOS)
		INCLUDE_TVOS=1
		PLATFORM_MBML="$PLATFORM_MBML<Var literal=\"tvOS\"/>"
		;;
		
	watchOS)
		INCLUDE_WATCHOS=1
		PLATFORM_MBML="$PLATFORM_MBML<Var literal=\"watchOS\"/>"
		;;
	esac
done

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
			if [[ -r "$REPO_SETTINGS_FILE" ]]; then
				$PLATE_BIN -t "$f" -o "${DEST_ROOT}/${DEST_DIR}${DEST_NAME}" -m ../include/repos.xml -d "$REPO_SETTINGS_FILE"
			else
				$PLATE_BIN -t "$f" -o "${DEST_ROOT}/${DEST_DIR}${DEST_NAME}" -m ../include/repos.xml --stdin-data <<MBML_BLOCK
<MBML>
	<Var name="repo:owner" literal="${REPO_OWNER}"/>
	<Var name="project:name" literal="${NEW_REPO_NAME}"/>
	<Var name="project:creator:name" literal="${CREATOR_NAME}"/>
	<Var name="project:creator:id" literal="${CREATOR_USER}"/>
	<Var name="project:platforms" type="list">
		$PLATFORM_MBML
	</Var>
</MBML>
MBML_BLOCK
			fi
			if [[ $( echo "$DEST_NAME" | grep -c "\.sh\$" ) > 0 ]]; then
				chmod a+x "${DEST_ROOT}/${DEST_DIR}${DEST_NAME}"
			fi
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

# we need to create the repo first because the freshenRepo.sh script below
# requires the git repo to already have been created & have at least 1 commit
pushd "$DEST_ROOT/$NEW_REPO_NAME" > /dev/null
if [[ ! -d .git ]]; then
	echo "Creating git repo and performing initial commit"
	git init
	git checkout -b "$REPO_BRANCH"
	git add .
	git commit -F - <<COMMIT_MESSAGE
Initial commit of $NEW_REPO_NAME

Automated by $SCRIPT_NAME
COMMIT_MESSAGE
else
	echo "It looks like $PWD is already under git control"
fi
popd > /dev/null

cd "$SCRIPT_DIR"/..
expectReposOnBranch "$REPO_BRANCH" "$NEW_REPO_NAME"

echo "Generating boilerplate files"
./bin/freshenRepo.sh --repo "$NEW_REPO_NAME" $FORCE_ARG $REPO_BRANCH_ARG

pushd "$DEST_ROOT/$NEW_REPO_NAME" > /dev/null

echo "Committing final files to git"
git add .
git commit -F - <<COMMIT_MESSAGE
Commit of $NEW_REPO_NAME

Automated by $SCRIPT_NAME
COMMIT_MESSAGE

popd > /dev/null
echo "Done!"
