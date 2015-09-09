#!/usr/bin/env bash
set -x

HIERA_HOME=/etc/puppet/hieradata
HIERA_HOME=/tmp/git

#space separated list of subdirs to apply this to
ENVIRONMENT="$1"  # eg nectar
DEFAULT_BRANCH=master
EXPECTED_BRANCH="${2-$DEFAULT_BRANCH}"

echo '###DEBUG###'
echo "1 ${1}"
echo "2 ${2}"
echo "ENVIRONMENT ${ENVIRONMENT} "
echo "EXPECTED_BRANCH ${EXPECTED_BRANCH}"
echo '###########'

function usage {
printf "usage: $0 environment [branch]\n"
printf "\n branch defaults to master.\n"
}

if [ -z "$1" ]
then
  usage
  exit 2
fi

cd $HIERA_HOME/$ENVIRONMENT
pwd
git status
if git status | grep 'nothing to commit, working directory clean'
then
  if git status | grep "On branch $EXPECTED_BRANCH"
  then
    git pull
  else
    printf "$HIERA_HOME/$ENVIRONMENT does not seem to be on expected branch "
    printf "${EXPECTED_BRANCH}, aborting.\n"
  fi
else
   printf "$HIERA_HOME/$ENVIRONMENT has uncommitted changes, aborting.\n" 1>&2
   exit 1
fi



