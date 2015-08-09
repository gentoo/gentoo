# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: git-2.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# Donnie Berkholz <dberkholz@gentoo.org>
# @BLURB: Eclass for fetching and unpacking git repositories.
# @DESCRIPTION:
# Eclass for easing maitenance of live ebuilds using git as remote repository.
# Eclass support working with git submodules and branching.
#
# This eclass is DEPRECATED. Please use git-r3 instead.

# This eclass support all EAPIs
EXPORT_FUNCTIONS src_unpack

DEPEND="dev-vcs/git"

# @ECLASS-VARIABLE: EGIT_SOURCEDIR
# @DESCRIPTION:
# This variable specifies destination where the cloned
# data are copied to.
#
# EGIT_SOURCEDIR="${S}"

# @ECLASS-VARIABLE: EGIT_STORE_DIR
# @DESCRIPTION:
# Storage directory for git sources.
#
# EGIT_STORE_DIR="${DISTDIR}/egit-src"

# @ECLASS-VARIABLE: EGIT_HAS_SUBMODULES
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable enables support for git submodules in our
# checkout. Also this makes the checkout to be non-bare for now.

# @ECLASS-VARIABLE: EGIT_OPTIONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Variable specifying additional options for fetch command.

# @ECLASS-VARIABLE: EGIT_MASTER
# @DESCRIPTION:
# Variable for specifying master branch.
# Usefull when upstream don't have master branch or name it differently.
#
# EGIT_MASTER="master"

# @ECLASS-VARIABLE: EGIT_PROJECT
# @DESCRIPTION:
# Variable specifying name for the folder where we check out the git
# repository. Value of this variable should be unique in the
# EGIT_STORE_DIR as otherwise you would override another repository.
#
# EGIT_PROJECT="${EGIT_REPO_URI##*/}"

# @ECLASS-VARIABLE: EGIT_DIR
# @DESCRIPTION:
# Directory where we want to store the git data.
# This variable should not be overriden.
#
# EGIT_DIR="${EGIT_STORE_DIR}/${EGIT_PROJECT}"

# @ECLASS-VARIABLE: EGIT_REPO_URI
# @REQUIRED
# @DEFAULT_UNSET
# @DESCRIPTION:
# URI for the repository
# e.g. http://foo, git://bar
#
# It can be overriden via env using packagename_LIVE_REPO
# variable.
#
# Support multiple values:
# EGIT_REPO_URI="git://a/b.git http://c/d.git"

# @ECLASS-VARIABLE: EVCS_OFFLINE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable prevents performance of any online
# operations.

# @ECLASS-VARIABLE: EGIT_BRANCH
# @DESCRIPTION:
# Variable containing branch name we want to check out.
# It can be overriden via env using packagename_LIVE_BRANCH
# variable.
#
# EGIT_BRANCH="${EGIT_MASTER}"

# @ECLASS-VARIABLE: EGIT_COMMIT
# @DESCRIPTION:
# Variable containing commit hash/tag we want to check out.
# It can be overriden via env using packagename_LIVE_COMMIT
# variable.
#
# EGIT_COMMIT="${EGIT_BRANCH}"

# @ECLASS-VARIABLE: EGIT_REPACK
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable specifies that repository will be repacked to
# save space. However this can take a REALLY LONG time with VERY big
# repositories.

# @ECLASS-VARIABLE: EGIT_PRUNE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable enables pruning all loose objects on each fetch.
# This is useful if upstream rewinds and rebases branches often.

# @ECLASS-VARIABLE: EGIT_NONBARE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable specifies that all checkouts will be done using
# non bare repositories. This is useful if you can't operate with bare
# checkouts for some reason.

# @ECLASS-VARIABLE: EGIT_NOUNPACK
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty this variable bans unpacking of ${A} content into the srcdir.
# Default behaviour is to unpack ${A} content.

# @FUNCTION: git-2_init_variables
# @INTERNAL
# @DESCRIPTION:
# Internal function initializing all git variables.
# We define it in function scope so user can define
# all the variables before and after inherit.
git-2_init_variables() {
	debug-print-function ${FUNCNAME} "$@"

	local esc_pn liverepo livebranch livecommit
	esc_pn=${PN//[-+]/_}

	: ${EGIT_SOURCEDIR="${S}"}

	: ${EGIT_STORE_DIR:="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/egit-src"}

	: ${EGIT_HAS_SUBMODULES:=}

	: ${EGIT_OPTIONS:=}

	: ${EGIT_MASTER:=master}

	liverepo=${esc_pn}_LIVE_REPO
	EGIT_REPO_URI=${!liverepo:-${EGIT_REPO_URI}}
	[[ ${EGIT_REPO_URI} ]] || die "EGIT_REPO_URI must have some value"

	: ${EVCS_OFFLINE:=}

	livebranch=${esc_pn}_LIVE_BRANCH
	[[ ${!livebranch} ]] && ewarn "QA: using \"${esc_pn}_LIVE_BRANCH\" variable, you won't get any support"
	EGIT_BRANCH=${!livebranch:-${EGIT_BRANCH:-${EGIT_MASTER}}}

	livecommit=${esc_pn}_LIVE_COMMIT
	[[ ${!livecommit} ]] && ewarn "QA: using \"${esc_pn}_LIVE_COMMIT\" variable, you won't get any support"
	EGIT_COMMIT=${!livecommit:-${EGIT_COMMIT:-${EGIT_BRANCH}}}

	: ${EGIT_REPACK:=}

	: ${EGIT_PRUNE:=}
}

# @FUNCTION: git-2_submodules
# @INTERNAL
# @DESCRIPTION:
# Internal function wrapping the submodule initialisation and update.
git-2_submodules() {
	debug-print-function ${FUNCNAME} "$@"
	if [[ ${EGIT_HAS_SUBMODULES} ]]; then
		if [[ ${EVCS_OFFLINE} ]]; then
			# for submodules operations we need to be online
			debug-print "${FUNCNAME}: not updating submodules in offline mode"
			return 1
		fi

		debug-print "${FUNCNAME}: working in \"${1}\""
		pushd "${EGIT_DIR}" > /dev/null

		debug-print "${FUNCNAME}: git submodule init"
		git submodule init || die
		debug-print "${FUNCNAME}: git submodule sync"
		git submodule sync || die
		debug-print "${FUNCNAME}: git submodule update"
		git submodule update || die

		popd > /dev/null
	fi
}

# @FUNCTION: git-2_branch
# @INTERNAL
# @DESCRIPTION:
# Internal function that changes branch for the repo based on EGIT_COMMIT and
# EGIT_BRANCH variables.
git-2_branch() {
	debug-print-function ${FUNCNAME} "$@"

	local branchname src

	debug-print "${FUNCNAME}: working in \"${EGIT_SOURCEDIR}\""
	pushd "${EGIT_SOURCEDIR}" > /dev/null

	local branchname=branch-${EGIT_BRANCH} src=origin/${EGIT_BRANCH}
	if [[ ${EGIT_COMMIT} != ${EGIT_BRANCH} ]]; then
		branchname=tree-${EGIT_COMMIT}
		src=${EGIT_COMMIT}
	fi
	debug-print "${FUNCNAME}: git checkout -b ${branchname} ${src}"
	git checkout -b ${branchname} ${src} \
		|| die "${FUNCNAME}: changing the branch failed"

	popd > /dev/null
}

# @FUNCTION: git-2_gc
# @INTERNAL
# @DESCRIPTION:
# Internal function running garbage collector on checked out tree.
git-2_gc() {
	debug-print-function ${FUNCNAME} "$@"

	local args

	if [[ ${EGIT_REPACK} || ${EGIT_PRUNE} ]]; then
		pushd "${EGIT_DIR}" > /dev/null
		ebegin "Garbage collecting the repository"
		[[ ${EGIT_PRUNE} ]] && args='--prune'
		debug-print "${FUNCNAME}: git gc ${args}"
		git gc ${args}
		eend $?
		popd > /dev/null
	fi
}

# @FUNCTION: git-2_prepare_storedir
# @INTERNAL
# @DESCRIPTION:
# Internal function preparing directory where we are going to store SCM
# repository.
git-2_prepare_storedir() {
	debug-print-function ${FUNCNAME} "$@"

	local clone_dir

	# initial clone, we have to create master git storage directory and play
	# nicely with sandbox
	if [[ ! -d ${EGIT_STORE_DIR} ]]; then
		debug-print "${FUNCNAME}: Creating git main storage directory"
		addwrite /
		mkdir -m 775 -p "${EGIT_STORE_DIR}" \
			|| die "${FUNCNAME}: can't mkdir \"${EGIT_STORE_DIR}\""
	fi

	# allow writing into EGIT_STORE_DIR
	addwrite "${EGIT_STORE_DIR}"

	# calculate git.eclass store dir for data
	# We will try to clone the old repository,
	# and we will remove it if we don't need it anymore.
	EGIT_OLD_CLONE=
	if [[ ${EGIT_STORE_DIR} == */egit-src ]]; then
		local old_store_dir=${EGIT_STORE_DIR/%egit-src/git-src}
		local old_location=${old_store_dir}/${EGIT_PROJECT:-${PN}}

		if [[ -d ${old_location} ]]; then
			EGIT_OLD_CLONE=${old_location}
			# required to remove the old clone
			addwrite "${old_store_dir}"
		fi
	fi

	# calculate the proper store dir for data
	# If user didn't specify the EGIT_DIR, we check if he did specify
	# the EGIT_PROJECT or get the folder name from EGIT_REPO_URI.
	EGIT_REPO_URI=${EGIT_REPO_URI%/}
	if [[ ! ${EGIT_DIR} ]]; then
		if [[ ${EGIT_PROJECT} ]]; then
			clone_dir=${EGIT_PROJECT}
		else
			local strippeduri=${EGIT_REPO_URI%/.git}
			clone_dir=${strippeduri##*/}
		fi
		EGIT_DIR=${EGIT_STORE_DIR}/${clone_dir}

		if [[ ${EGIT_OLD_CLONE} && ! -d ${EGIT_DIR} ]]; then
			elog "${FUNCNAME}: ${CATEGORY}/${PF} will be cloned from old location."
			elog "It will be necessary to rebuild the package to fetch updates."
			EGIT_REPO_URI="${EGIT_OLD_CLONE} ${EGIT_REPO_URI}"
		fi
	fi
	export EGIT_DIR=${EGIT_DIR}
	debug-print "${FUNCNAME}: Storing the repo into \"${EGIT_DIR}\"."
}

# @FUNCTION: git-2_move_source
# @INTERNAL
# @DESCRIPTION:
# Internal function moving sources from the EGIT_DIR to EGIT_SOURCEDIR dir.
git-2_move_source() {
	debug-print-function ${FUNCNAME} "$@"

	debug-print "${FUNCNAME}: ${MOVE_COMMAND} \"${EGIT_DIR}\" \"${EGIT_SOURCEDIR}\""
	pushd "${EGIT_DIR}" > /dev/null
	mkdir -p "${EGIT_SOURCEDIR}" \
		|| die "${FUNCNAME}: failed to create ${EGIT_SOURCEDIR}"
	${MOVE_COMMAND} "${EGIT_SOURCEDIR}" \
		|| die "${FUNCNAME}: sync to \"${EGIT_SOURCEDIR}\" failed"
	popd > /dev/null
}

# @FUNCTION: git-2_initial_clone
# @INTERNAL
# @DESCRIPTION:
# Internal function running initial clone on specified repo_uri.
git-2_initial_clone() {
	debug-print-function ${FUNCNAME} "$@"

	local repo_uri

	EGIT_REPO_URI_SELECTED=""
	for repo_uri in ${EGIT_REPO_URI}; do
		debug-print "${FUNCNAME}: git clone ${EGIT_LOCAL_OPTIONS} \"${repo_uri}\" \"${EGIT_DIR}\""
		if git clone ${EGIT_LOCAL_OPTIONS} "${repo_uri}" "${EGIT_DIR}"; then
			# global variable containing the repo_name we will be using
			debug-print "${FUNCNAME}: EGIT_REPO_URI_SELECTED=\"${repo_uri}\""
			EGIT_REPO_URI_SELECTED="${repo_uri}"
			break
		fi
	done

	[[ ${EGIT_REPO_URI_SELECTED} ]] \
		|| die "${FUNCNAME}: can't fetch from ${EGIT_REPO_URI}"
}

# @FUNCTION: git-2_update_repo
# @INTERNAL
# @DESCRIPTION:
# Internal function running update command on specified repo_uri.
git-2_update_repo() {
	debug-print-function ${FUNCNAME} "$@"

	local repo_uri

	if [[ ${EGIT_LOCAL_NONBARE} ]]; then
		# checkout master branch and drop all other local branches
		git checkout ${EGIT_MASTER} || die "${FUNCNAME}: can't checkout master branch ${EGIT_MASTER}"
		for x in $(git branch | grep -v "* ${EGIT_MASTER}" | tr '\n' ' '); do
			debug-print "${FUNCNAME}: git branch -D ${x}"
			git branch -D ${x} > /dev/null
		done
	fi

	EGIT_REPO_URI_SELECTED=""
	for repo_uri in ${EGIT_REPO_URI}; do
		# git urls might change, so reset it
		git config remote.origin.url "${repo_uri}"

		debug-print "${EGIT_UPDATE_CMD}"
		if ${EGIT_UPDATE_CMD} > /dev/null; then
			# global variable containing the repo_name we will be using
			debug-print "${FUNCNAME}: EGIT_REPO_URI_SELECTED=\"${repo_uri}\""
			EGIT_REPO_URI_SELECTED="${repo_uri}"
			break
		fi
	done

	[[ ${EGIT_REPO_URI_SELECTED} ]] \
		|| die "${FUNCNAME}: can't update from ${EGIT_REPO_URI}"
}

# @FUNCTION: git-2_fetch
# @INTERNAL
# @DESCRIPTION:
# Internal function fetching repository from EGIT_REPO_URI and storing it in
# specified EGIT_STORE_DIR.
git-2_fetch() {
	debug-print-function ${FUNCNAME} "$@"

	local oldsha cursha repo_type

	[[ ${EGIT_LOCAL_NONBARE} ]] && repo_type="non-bare repository" || repo_type="bare repository"

	if [[ ! -d ${EGIT_DIR} ]]; then
		git-2_initial_clone
		pushd "${EGIT_DIR}" > /dev/null
		cursha=$(git rev-parse ${UPSTREAM_BRANCH})
		echo "GIT NEW clone -->"
		echo "   repository:               ${EGIT_REPO_URI_SELECTED}"
		echo "   at the commit:            ${cursha}"

		popd > /dev/null
	elif [[ ${EVCS_OFFLINE} ]]; then
		pushd "${EGIT_DIR}" > /dev/null
		cursha=$(git rev-parse ${UPSTREAM_BRANCH})
		echo "GIT offline update -->"
		echo "   repository:               $(git config remote.origin.url)"
		echo "   at the commit:            ${cursha}"
		popd > /dev/null
	else
		pushd "${EGIT_DIR}" > /dev/null
		oldsha=$(git rev-parse ${UPSTREAM_BRANCH})
		git-2_update_repo
		cursha=$(git rev-parse ${UPSTREAM_BRANCH})

		# fetch updates
		echo "GIT update -->"
		echo "   repository:               ${EGIT_REPO_URI_SELECTED}"
		# write out message based on the revisions
		if [[ "${oldsha}" != "${cursha}" ]]; then
			echo "   updating from commit:     ${oldsha}"
			echo "   to commit:                ${cursha}"
		else
			echo "   at the commit:            ${cursha}"
		fi

		# print nice statistic of what was changed
		git --no-pager diff --stat ${oldsha}..${UPSTREAM_BRANCH}
		popd > /dev/null
	fi
	# export the version the repository is at
	export EGIT_VERSION="${cursha}"
	# log the repo state
	[[ ${EGIT_COMMIT} != ${EGIT_BRANCH} ]] \
		&& echo "   commit:                   ${EGIT_COMMIT}"
	echo "   branch:                   ${EGIT_BRANCH}"
	echo "   storage directory:        \"${EGIT_DIR}\""
	echo "   checkout type:            ${repo_type}"

	# Cleanup after git.eclass
	if [[ ${EGIT_OLD_CLONE} ]]; then
		einfo "${FUNCNAME}: removing old clone in ${EGIT_OLD_CLONE}."
		rm -rf "${EGIT_OLD_CLONE}"
	fi
}

# @FUNCTION: git_bootstrap
# @INTERNAL
# @DESCRIPTION:
# Internal function that runs bootstrap command on unpacked source.
git-2_bootstrap() {
	debug-print-function ${FUNCNAME} "$@"

	# @ECLASS-VARIABLE: EGIT_BOOTSTRAP
	# @DESCRIPTION:
	# Command to be executed after checkout and clone of the specified
	# repository.
	# enviroment the package will fail if there is no update, thus in
	# combination with --keep-going it would lead in not-updating
	# pakcages that are up-to-date.
	if [[ ${EGIT_BOOTSTRAP} ]]; then
		pushd "${EGIT_SOURCEDIR}" > /dev/null
		einfo "Starting bootstrap"

		if [[ -f ${EGIT_BOOTSTRAP} ]]; then
			# we have file in the repo which we should execute
			debug-print "${FUNCNAME}: bootstraping with file \"${EGIT_BOOTSTRAP}\""

			if [[ -x ${EGIT_BOOTSTRAP} ]]; then
				eval "./${EGIT_BOOTSTRAP}" \
					|| die "${FUNCNAME}: bootstrap script failed"
			else
				eerror "\"${EGIT_BOOTSTRAP}\" is not executable."
				eerror "Report upstream, or bug ebuild maintainer to remove bootstrap command."
				die "\"${EGIT_BOOTSTRAP}\" is not executable"
			fi
		else
			# we execute some system command
			debug-print "${FUNCNAME}: bootstraping with commands \"${EGIT_BOOTSTRAP}\""

			eval "${EGIT_BOOTSTRAP}" \
				|| die "${FUNCNAME}: bootstrap commands failed"
		fi

		einfo "Bootstrap finished"
		popd > /dev/null
	fi
}

# @FUNCTION: git-2_migrate_repository
# @INTERNAL
# @DESCRIPTION:
# Internal function migrating between bare and normal checkout repository.
# This is based on usage of EGIT_SUBMODULES, at least until they
# start to work with bare checkouts sanely.
# This function also set some global variables that differ between
# bare and non-bare checkout.
git-2_migrate_repository() {
	debug-print-function ${FUNCNAME} "$@"

	local bare returnstate

	# first find out if we have submodules
	# or user explicitly wants us to use non-bare clones
	if ! [[ ${EGIT_HAS_SUBMODULES} || ${EGIT_NONBARE} ]]; then
		bare=1
	fi

	# test if we already have some repo and if so find out if we have
	# to migrate the data
	if [[ -d ${EGIT_DIR} ]]; then
		if [[ ${bare} && -d ${EGIT_DIR}/.git ]]; then
			debug-print "${FUNCNAME}: converting \"${EGIT_DIR}\" to bare copy"

			ebegin "Converting \"${EGIT_DIR}\" from non-bare to bare copy"
			mv "${EGIT_DIR}/.git" "${EGIT_DIR}.bare"
			export GIT_DIR="${EGIT_DIR}.bare"
			git config core.bare true > /dev/null
			returnstate=$?
			unset GIT_DIR
			rm -rf "${EGIT_DIR}"
			mv "${EGIT_DIR}.bare" "${EGIT_DIR}"
			eend ${returnstate}
		elif [[ ! ${bare} && ! -d ${EGIT_DIR}/.git ]]; then
			debug-print "${FUNCNAME}: converting \"${EGIT_DIR}\" to non-bare copy"

			ebegin "Converting \"${EGIT_DIR}\" from bare to non-bare copy"
			git clone -l "${EGIT_DIR}" "${EGIT_DIR}.nonbare" > /dev/null
			returnstate=$?
			rm -rf "${EGIT_DIR}"
			mv "${EGIT_DIR}.nonbare" "${EGIT_DIR}"
			eend ${returnstate}
		fi
	fi
	if [[ ${returnstate} -ne 0 ]]; then
		debug-print "${FUNCNAME}: converting \"${EGIT_DIR}\" failed, removing to start from scratch"

		# migration failed, remove the EGIT_DIR to play it safe
		einfo "Migration failed, removing \"${EGIT_DIR}\" to start from scratch."
		rm -rf "${EGIT_DIR}"
	fi

	# set various options to work with both targets
	if [[ ${bare} ]]; then
		debug-print "${FUNCNAME}: working in bare repository for \"${EGIT_DIR}\""
		EGIT_LOCAL_OPTIONS+="${EGIT_OPTIONS} --bare"
		MOVE_COMMAND="git clone -l -s -n ${EGIT_DIR// /\\ }"
		EGIT_UPDATE_CMD="git fetch -t -f -u origin ${EGIT_BRANCH}:${EGIT_BRANCH}"
		UPSTREAM_BRANCH="${EGIT_BRANCH}"
		EGIT_LOCAL_NONBARE=
	else
		debug-print "${FUNCNAME}: working in bare repository for non-bare \"${EGIT_DIR}\""
		MOVE_COMMAND="cp -pPR ."
		EGIT_LOCAL_OPTIONS="${EGIT_OPTIONS}"
		EGIT_UPDATE_CMD="git pull -f -u ${EGIT_OPTIONS}"
		UPSTREAM_BRANCH="origin/${EGIT_BRANCH}"
		EGIT_LOCAL_NONBARE="true"
	fi
}

# @FUNCTION: git-2_cleanup
# @INTERNAL
# @DESCRIPTION:
# Internal function cleaning up all the global variables
# that are not required after the unpack has been done.
git-2_cleanup() {
	debug-print-function ${FUNCNAME} "$@"

	# Here we can unset only variables that are GLOBAL
	# defined by the eclass, BUT NOT subject to change
	# by user (like EGIT_PROJECT).
	# If ebuild writer polutes his environment it is
	# his problem only.
	unset EGIT_DIR
	unset MOVE_COMMAND
	unset EGIT_LOCAL_OPTIONS
	unset EGIT_UPDATE_CMD
	unset UPSTREAM_BRANCH
	unset EGIT_LOCAL_NONBARE
}

# @FUNCTION: git-2_src_unpack
# @DESCRIPTION:
# Default git src_unpack function.
git-2_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	git-2_init_variables
	git-2_prepare_storedir
	git-2_migrate_repository
	git-2_fetch "$@"
	git-2_gc
	git-2_submodules
	git-2_move_source
	git-2_branch
	git-2_bootstrap
	git-2_cleanup
	echo ">>> Unpacked to ${EGIT_SOURCEDIR}"

	# Users can specify some SRC_URI and we should
	# unpack the files too.
	if [[ ! ${EGIT_NOUNPACK} ]]; then
		if has ${EAPI:-0} 0 1; then
			[[ ${A} ]] && unpack ${A}
		else
			default_src_unpack
		fi
	fi
}
