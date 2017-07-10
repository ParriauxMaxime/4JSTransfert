#!/bin/bash
printf "In order to activate this functionality,\nyou will need to set several environement variables.\n"

startServer() {
	npm start&
}

if [ -z $NODE_PATH ] && [ -z $GBC_PATH ]; then
	Path=""
	UserInputForEnv(){
		Name=$1
		Description=$2
		DefaultPath=$3

		if [ -z $(printenv $Name) ]; then
			if [ -z $DefaultPath ]; then
				read -e -p "\$$Name $Description: " Path
			else
				read -e -p "\$$Name $Description (default: '${DefaultPath}'): " Path;
			fi

		fi

		if [ -z $Path ] && [ -z $DefaultPath ]; then
			printf "No path was defined for $Name, aborting..\n";
			exit 1;
		elif [ -z $Path ]; then
			Path=$DefaultPath
			printf "Using default path: $DefaultPath\n"
		else
			printf "Using $Name=$Path\n";
		fi
		return 0
	}

	printf "\n"

	UserInputForEnvNode() {
		UserInputForEnv "NODE" "is the path to Node.js executable\nEnter path to node executable" "/usr/bin/node"
	}
	UserInputForEnvNode
	NODE_PATH=$Path
	export NODE_PATH=$NODE_PATH

	printf "\n"

	UserInputForEnvGBC() {
		UserInputForEnv "GBCDIR" "is the path to the GBC directory (also known as client-javascript).\nEnter path to GBC directory" ""
	}
	UserInputForEnvGBC
	GBC_PATH=$Path
	export GBC_PATH=$GBC_PATH

	VerifyPath() {
		if [ -f "$NODE_PATH" ] && [ -d "$GBC_PATH" ]; then
			return 0
		else
			return 1
		fi
	}

	installNodePackage() {
		cd $GBC_PATH
		npm install
	}


	VerifyPath
	if [ $? -eq 1 ]; then
		printf "One of the path you provided seems to be incorrect.\nAborting..."
	else
		printf "Starting the theme configuration server\nCould take several minutes.." 
	    	installNodePackage
		startServer
	fi
else
	startServer
fi
