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

executeCommand()
{
	if [[ $DRY_RUN_MODE ]]; then
		if [[ ! $DID_DRY_RUN_MSG ]]; then
			printf "\t!!! DRY RUN MODE - Will only show commands, not execute them !!!\n"
			echo
			DID_DRY_RUN_MSG=1
		fi
		echo "> $1"
	else
		eval "$1"
		if [[ $? != 0 ]]; then
			exitWithError "Command failed"
		fi
	fi
}

isNotRepo()
{
	REPO_DIR="$1"
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
		echo "error: Expected $1 (within $PWD) to be a git repo"
		exit 1
	fi
}

isInArray()
{
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 1; done
	return 0
}

CLEANROOM_REPOS=()
for f in "$SCRIPT_DIR/../repos/"*.xml; do
	CLEANROOM_REPOS+=(`basename "$f" | sed "s/^repos\///" | sed "s/.xml$//"`)
done
