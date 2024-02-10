# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: git-r3.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Eclass for fetching and unpacking git repositories.
# @DESCRIPTION:
# Third generation eclass for easing maintenance of live ebuilds using
# git as remote repository.

# @ECLASS_VARIABLE: EGIT_LFS
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set, git lfs support will be enabled.
# Set before inheriting this eclass.

# @ECLASS_VARIABLE: _NUM_LFS_FILTERS_FOUND
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is used to provide QA warnings if a repo has git lfs filters
# defined but EGIT_LFS is not turned on and vice versa.
# If non-empty, then the repo likely needs EGIT_LFS to clone properly.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GIT_R3_ECLASS} ]]; then
_GIT_R3_ECLASS=1

PROPERTIES+=" live"

if [[ ${EAPI} != 6 ]]; then
	BDEPEND=">=dev-vcs/git-1.8.2.1[curl]"
	[[ ${EGIT_LFS} ]] && BDEPEND+=" dev-vcs/git-lfs"
else
	DEPEND=">=dev-vcs/git-1.8.2.1[curl]"
	[[ ${EGIT_LFS} ]] && DEPEND+=" dev-vcs/git-lfs"
fi

# @ECLASS_VARIABLE: EGIT_CLONE_TYPE
# @USER_VARIABLE
# @DESCRIPTION:
# Type of clone that should be used against the remote repository.
# This can be either of: 'mirror', 'single', 'shallow'.
#
# This is intended to be set by user in make.conf. Ebuilds are supposed
# to set EGIT_MIN_CLONE_TYPE if necessary instead.
#
# The 'mirror' type clones all remote branches and tags with complete
# history and all notes. EGIT_COMMIT can specify any commit hash.
# Upstream-removed branches and tags are purged from the local clone
# while fetching. This mode is suitable for cloning the local copy
# for development or hosting a local git mirror. However, clones
# of repositories with large diverged branches may quickly grow large.
#
# The 'single+tags' type clones the requested branch and all tags
# in the repository. All notes are fetched as well. EGIT_COMMIT
# can safely specify hashes throughout the current branch and all tags.
# No purging of old references is done (if you often switch branches,
# you may need to remove stale branches yourself). This mode is intended
# mostly for use with broken git servers such as Google Code that fail
# to fetch tags along with the branch in 'single' mode.
#
# The 'single' type clones only the requested branch or tag. Tags
# referencing commits throughout the branch history are fetched as well,
# and all notes. EGIT_COMMIT can safely specify only hashes
# in the current branch. No purging of old references is done (if you
# often switch branches, you may need to remove stale branches
# yourself). This mode is suitable for general use.
#
# The 'shallow' type clones only the newest commit on requested branch
# or tag. EGIT_COMMIT can only specify tags, and since the history is
# unavailable calls like 'git describe' will not reference prior tags.
# No purging of old references is done. This mode is intended mostly for
# embedded systems with limited disk space.
: "${EGIT_CLONE_TYPE:=single}"

# @ECLASS_VARIABLE: EGIT_MIN_CLONE_TYPE
# @DESCRIPTION:
# 'Minimum' clone type supported by the ebuild. Takes same values
# as EGIT_CLONE_TYPE. When user sets a type that's 'lower' (that is,
# later on the list) than EGIT_MIN_CLONE_TYPE, the eclass uses
# EGIT_MIN_CLONE_TYPE instead.
#
# This variable is intended to be used by ebuilds only. Users are
# supposed to set EGIT_CLONE_TYPE instead.
#
# A common case is to use 'single' whenever the build system requires
# access to full branch history, or 'single+tags' when Google Code
# or a similar remote is used that does not support shallow clones
# and fetching tags along with commits. Please use sparingly, and to fix
# fatal errors rather than 'non-pretty versions'.
: "${EGIT_MIN_CLONE_TYPE:=shallow}"

# @ECLASS_VARIABLE: EGIT_LFS_CLONE_TYPE
# @USER_VARIABLE
# @DESCRIPTION:
# Type of lfs clone that should be used against the remote repository.
# This can be either of: 'mirror', 'single', 'shallow'.
#
# This works a bit differently than EGIT_CLONE_TYPE.
#
# The 'mirror' type clones all LFS files that is available from the
# cloned repo. Is is mostly useful for backup or rehosting purposes as
# the disk usage will be excessive.
#
# The 'single' type clones only the LFS files from the current commit.
# However unlike 'shallow', it will not cleanup stale LFS files.
#
# The 'shallow' type clones only the LFS files from the current commit.
# LFS files that are not referenced by the current commit and more than
# a few days old will be automatically removed to save disk space.
# This is the recommended mode for LFS repos to prevent excessive disk
# usage.
: "${EGIT_LFS_CLONE_TYPE:=shallow}"

# @ECLASS_VARIABLE: EVCS_STORE_DIRS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Record of names of all the repositories directories being cloned in the git3_src.
# This is useful in the case of ebuild that fetch multiple repos and
# it would be used by eclean to clean them up.
EVCS_STORE_DIRS=()

# @ECLASS_VARIABLE: EGIT3_STORE_DIR
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Storage directory for git sources.
#
# This is intended to be set by user in make.conf. Ebuilds must not set
# it.
#
# EGIT3_STORE_DIR=${DISTDIR}/git3-src

# @ECLASS_VARIABLE: EGIT_MIRROR_URI
# @DEFAULT_UNSET
# @DESCRIPTION:
# 'Top' URI to a local git mirror. If specified, the eclass will try
# to fetch from the local mirror instead of using the remote repository.
#
# The mirror needs to follow EGIT3_STORE_DIR structure. The directory
# created by eclass can be used for that purpose.
#
# Example:
# @CODE
# EGIT_MIRROR_URI="git://mirror.lan/"
# @CODE

# @ECLASS_VARIABLE: EGIT_REPO_URI
# @REQUIRED
# @DESCRIPTION:
# URIs to the repository, e.g. https://foo. If multiple URIs are
# provided, the eclass will consider the remaining URIs as fallbacks
# to try if the first URI does not work. For supported URI syntaxes,
# read the manpage for git-clone(1).
#
# URIs should be using https:// whenever possible. http:// and git://
# URIs are completely insecure and their use (even if only as
# a fallback) renders the ebuild completely vulnerable to MITM attacks.
#
# Can be a whitespace-separated list or an array.
#
# Example:
# @CODE
# EGIT_REPO_URI="https://a/b.git https://c/d.git"
# @CODE

# @ECLASS_VARIABLE: EVCS_OFFLINE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty, this variable prevents any online operations.

# @ECLASS_VARIABLE: EVCS_UMASK
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable to a custom umask. This is intended to be set by
# users. By setting this to something like 002, it can make life easier
# for people who do development as non-root (but are in the portage
# group), and then switch over to building with FEATURES=userpriv.
# Or vice-versa. Shouldn't be a security issue here as anyone who has
# portage group write access already can screw the system over in more
# creative ways.

# @ECLASS_VARIABLE: EGIT_BRANCH
# @DEFAULT_UNSET
# @DESCRIPTION:
# The branch name to check out. If unset, the upstream default (HEAD)
# will be used.

# @ECLASS_VARIABLE: EGIT_COMMIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# The tag name or commit identifier to check out. If unset, newest
# commit from the branch will be used. Note that if set to a commit
# not on HEAD branch, EGIT_BRANCH needs to be set to a branch on which
# the commit is available.

# @ECLASS_VARIABLE: EGIT_COMMIT_DATE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Attempt to check out the repository state for the specified timestamp.
# The date should be in format understood by 'git rev-list'. The commits
# on EGIT_BRANCH will be considered.
#
# The eclass will select the last commit with commit date preceding
# the specified date. When merge commits are found, only first parents
# will be considered in order to avoid switching into external branches
# (assuming that merges are done correctly). In other words, each merge
# will be considered alike a single commit with date corresponding
# to the merge commit date.

# @ECLASS_VARIABLE: EGIT_CHECKOUT_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# The directory to check the git sources out to.
#
# EGIT_CHECKOUT_DIR=${WORKDIR}/${P}

# @ECLASS_VARIABLE: EGIT_SUBMODULES
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of inclusive and exclusive wildcards on submodule names,
# stating which submodules are fetched and checked out. Exclusions
# start with '-', and exclude previously matched submodules.
#
# If unset, all submodules are enabled. Empty list disables all
# submodules. In order to use an exclude-only list, start the array
# with '*'.
#
# Remember that wildcards need to be quoted in order to prevent filename
# expansion.
#
# Examples:
# @CODE
# # Disable all submodules
# EGIT_SUBMODULES=()
#
# # Include only foo and bar
# EGIT_SUBMODULES=( foo bar )
#
# # Use all submodules except for test-* but include test-lib
# EGIT_SUBMODULES=( '*' '-test-*' test-lib )
# @CODE

# @FUNCTION: _git-r3_env_setup
# @INTERNAL
# @DESCRIPTION:
# Set the eclass variables as necessary for operation. This can involve
# setting EGIT_* to defaults or ${PN}_LIVE_* variables.
_git-r3_env_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# check the clone type
	case "${EGIT_CLONE_TYPE}" in
		mirror|single+tags|single|shallow)
			;;
		*)
			die "Invalid EGIT_CLONE_TYPE=${EGIT_CLONE_TYPE}"
	esac
	case "${EGIT_MIN_CLONE_TYPE}" in
		shallow)
			;;
		single)
			if [[ ${EGIT_CLONE_TYPE} == shallow ]]; then
				einfo "git-r3: ebuild needs to be cloned in 'single' mode, adjusting"
				EGIT_CLONE_TYPE=single
			fi
			;;
		single+tags)
			if [[ ${EGIT_CLONE_TYPE} == shallow || ${EGIT_CLONE_TYPE} == single ]]; then
				einfo "git-r3: ebuild needs to be cloned in 'single+tags' mode, adjusting"
				EGIT_CLONE_TYPE=single+tags
			fi
			;;
		mirror)
			if [[ ${EGIT_CLONE_TYPE} != mirror ]]; then
				einfo "git-r3: ebuild needs to be cloned in 'mirror' mode, adjusting"
				EGIT_CLONE_TYPE=mirror
			fi
			;;
		*)
			die "Invalid EGIT_MIN_CLONE_TYPE=${EGIT_MIN_CLONE_TYPE}"
	esac

	if [[ ${EGIT_SUBMODULES[@]+1} && $(declare -p EGIT_SUBMODULES) != "declare -a"* ]]
	then
		die 'EGIT_SUBMODULES must be an array.'
	fi

	local esc_pn livevar
	esc_pn=${PN//[-+]/_}
	[[ ${esc_pn} == [0-9]* ]] && esc_pn=_${esc_pn}

	# note: deprecated, use EGIT_OVERRIDE_* instead
	livevar=${esc_pn}_LIVE_REPO
	EGIT_REPO_URI=${!livevar-${EGIT_REPO_URI}}
	[[ ${!livevar} ]] \
		&& ewarn "Using ${livevar}, no support will be provided"

	livevar=${esc_pn}_LIVE_BRANCH
	EGIT_BRANCH=${!livevar-${EGIT_BRANCH}}
	[[ ${!livevar} ]] \
		&& ewarn "Using ${livevar}, no support will be provided"

	livevar=${esc_pn}_LIVE_COMMIT
	EGIT_COMMIT=${!livevar-${EGIT_COMMIT}}
	[[ ${!livevar} ]] \
		&& ewarn "Using ${livevar}, no support will be provided"

	livevar=${esc_pn}_LIVE_COMMIT_DATE
	EGIT_COMMIT_DATE=${!livevar-${EGIT_COMMIT_DATE}}
	[[ ${!livevar} ]] \
		&& ewarn "Using ${livevar}, no support will be provided"

	if [[ ${EGIT_COMMIT} && ${EGIT_COMMIT_DATE} ]]; then
		die "EGIT_COMMIT and EGIT_COMMIT_DATE can not be specified simultaneously"
	fi
}

# @FUNCTION: _git-r3_set_gitdir
# @USAGE: <repo-uri>
# @INTERNAL
# @DESCRIPTION:
# Obtain the local repository path and set it as GIT_DIR. Creates
# a new repository if necessary.
#
# <repo-uri> may be used to compose the path. It should therefore be
# a canonical URI to the repository.
_git-r3_set_gitdir() {
	debug-print-function ${FUNCNAME} "$@"

	local repo_name=${1#*://*/}

	# strip the trailing slash
	repo_name=${repo_name%/}

	# strip common prefixes to make paths more likely to match
	# e.g. git://X/Y.git vs https://X/git/Y.git
	# (but just one of the prefixes)
	case "${repo_name}" in
		# gnome.org... who else?
		browse/*) repo_name=${repo_name#browse/};;
		# cgit can proxy requests to git
		cgit/*) repo_name=${repo_name#cgit/};;
		# pretty common
		git/*) repo_name=${repo_name#git/};;
		# gentoo.org
		gitroot/*) repo_name=${repo_name#gitroot/};;
		# sourceforge
		p/*) repo_name=${repo_name#p/};;
		# kernel.org
		pub/scm/*) repo_name=${repo_name#pub/scm/};;
	esac
	# ensure a .git suffix, same reason
	repo_name=${repo_name%.git}.git
	# now replace all the slashes
	repo_name=${repo_name//\//_}

	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	: "${EGIT3_STORE_DIR:=${distdir}/git3-src}"

	GIT_DIR=${EGIT3_STORE_DIR}/${repo_name}

	EVCS_STORE_DIRS+=( "${GIT_DIR}" )

	if [[ ! -d ${EGIT3_STORE_DIR} && ! ${EVCS_OFFLINE} ]]; then
		(
			addwrite /
			mkdir -p "${EGIT3_STORE_DIR}"
		) || die "Unable to create ${EGIT3_STORE_DIR}"
	fi

	addwrite "${EGIT3_STORE_DIR}"
	if [[ ! -d ${GIT_DIR} ]]; then
		if [[ ${EVCS_OFFLINE} ]]; then
			eerror "A clone of the following repository is required to proceed:"
			eerror "  ${1}"
			eerror "However, networking activity has been disabled using EVCS_OFFLINE and there"
			eerror "is no local clone available."
			die "No local clone of ${1}. Unable to proceed with EVCS_OFFLINE."
		fi

		local saved_umask
		if [[ ${EVCS_UMASK} ]]; then
			saved_umask=$(umask)
			umask "${EVCS_UMASK}" || die "Bad options to umask: ${EVCS_UMASK}"
		fi
		mkdir "${GIT_DIR}" || die
		git init --bare -b __init__ || die
		if [[ ${saved_umask} ]]; then
			umask "${saved_umask}" || die
		fi
	fi
}

# @FUNCTION: _git-r3_set_submodules
# @USAGE: <parent-path> <file-contents>
# @INTERNAL
# @DESCRIPTION:
# Parse .gitmodules contents passed as <file-contents>
# as in "$(cat .gitmodules)"). Composes a 'submodules' array that
# contains in order (name, URL, path) for each submodule.
#
# <parent-path> specifies path to current submodule (empty if top repo),
# and is used to support recursively specifying submodules.  The path
# must include a trailing slash if it's not empty.
_git-r3_set_submodules() {
	debug-print-function ${FUNCNAME} "$@"

	local parent_path=${1}
	local data=${2}
	[[ -z ${parent_path} || ${parent_path} == */ ]] || die

	# ( name url path ... )
	submodules=()

	local l
	while read l; do
		# submodule.<path>.path=<path>
		# submodule.<path>.url=<url>
		[[ ${l} == submodule.*.url=* ]] || continue

		l=${l#submodule.}
		local subname=${l%%.url=*}

		# filter out on EGIT_SUBMODULES
		if declare -p EGIT_SUBMODULES &>/dev/null; then
			local p l_res res=
			for p in "${EGIT_SUBMODULES[@]}"; do
				if [[ ${p} == -* ]]; then
					p=${p#-}
					l_res=
				else
					l_res=1
				fi

				[[ ${parent_path}${subname} == ${p} ]] && res=${l_res}
			done

			if [[ ! ${res} ]]; then
				einfo "Skipping submodule ${parent_path}${subname}"
				continue
			else
				einfo "Using submodule ${parent_path}${subname}"
			fi
		fi

		# skip modules that have 'update = none', bug #487262.
		local upd=$(echo "${data}" | git config -f /dev/fd/0 \
			submodule."${subname}".update)
		[[ ${upd} == none ]] && continue

		# https://github.com/git/git/blob/master/refs.c#L31
		# we are more restrictive than git itself but that should not
		# cause any issues, #572312, #606950
		# TODO: check escaped names for collisions
		local enc_subname=${subname//[^a-zA-Z0-9-]/_}

		submodules+=(
			"${enc_subname}"
			"$(echo "${data}" | git config -f /dev/fd/0 \
				submodule."${subname}".url || die)"
			"$(echo "${data}" | git config -f /dev/fd/0 \
				submodule."${subname}".path || die)"
		)
	done < <(echo "${data}" | git config -f /dev/fd/0 -l || die)
}

# @FUNCTION: _git-r3_set_subrepos
# @USAGE: <submodule-uri> <parent-repo-uri>...
# @INTERNAL
# @DESCRIPTION:
# Create 'subrepos' array containing absolute (canonical) submodule URIs
# for the given <submodule-uri>. If the URI is relative, URIs will be
# constructed using all <parent-repo-uri>s. Otherwise, this single URI
# will be placed in the array.
_git-r3_set_subrepos() {
	debug-print-function ${FUNCNAME} "$@"

	local suburl=${1}
	subrepos=( "${@:2}" )

	if [[ ${suburl} == ./* || ${suburl} == ../* ]]; then
		# drop all possible trailing slashes for consistency
		subrepos=( "${subrepos[@]%%/}" )

		while true; do
			if [[ ${suburl} == ./* ]]; then
				suburl=${suburl:2}
			elif [[ ${suburl} == ../* ]]; then
				suburl=${suburl:3}

				# XXX: correctness checking

				# drop the last path component
				subrepos=( "${subrepos[@]%/*}" )
				# and then the trailing slashes, again
				subrepos=( "${subrepos[@]%%/}" )
			else
				break
			fi
		done

		# append the preprocessed path to the preprocessed URIs
		subrepos=( "${subrepos[@]/%//${suburl}}")
	else
		subrepos=( "${suburl}" )
	fi
}


# @FUNCTION: _git-r3_is_local_repo
# @USAGE: <repo-uri>
# @INTERNAL
# @DESCRIPTION:
# Determine whether the given URI specifies a local (on-disk)
# repository.
_git-r3_is_local_repo() {
	debug-print-function ${FUNCNAME} "$@"

	local uri=${1}

	[[ ${uri} == file://* || ${uri} == /* ]]
}

# @FUNCTION: git-r3_fetch
# @USAGE: [<repo-uri> [<remote-ref> [<local-id> [<commit-date>]]]]
# @DESCRIPTION:
# Fetch new commits to the local clone of repository.
#
# <repo-uri> specifies the repository URIs to fetch from, as a space-
# -separated list. The first URI will be used as repository group
# identifier and therefore must be used consistently. When not
# specified, defaults to ${EGIT_REPO_URI}.
#
# <remote-ref> specifies the remote ref or commit id to fetch.
# It is preferred to use 'refs/heads/<branch-name>' for branches
# and 'refs/tags/<tag-name>' for tags. Other options are 'HEAD'
# for upstream default branch and hexadecimal commit SHA1. Defaults
# to the first of EGIT_COMMIT, EGIT_BRANCH or literal 'HEAD' that
# is set to a non-null value.
#
# <local-id> specifies the local branch identifier that will be used to
# locally store the fetch result. It should be unique to multiple
# fetches within the repository that can be performed at the same time
# (including parallel merges). It defaults to ${CATEGORY}/${PN}/${SLOT%/*}.
# This default should be fine unless you are fetching multiple trees
# from the same repository in the same ebuild.
#
# <commit-date> requests attempting to use repository state as of specific
# date. For more details, see EGIT_COMMIT_DATE.
#
# The fetch operation will affect the EGIT_STORE only. It will not touch
# the working copy, nor export any environment variables.
# If the repository contains submodules, they will be fetched
# recursively.
git-r3_fetch() {
	debug-print-function ${FUNCNAME} "$@"

	# disable password prompts, https://bugs.gentoo.org/701276
	local -x GIT_TERMINAL_PROMPT=0

	# process repos first since we create repo_name from it
	local repos
	if [[ ${1} ]]; then
		repos=( ${1} )
	elif [[ $(declare -p EGIT_REPO_URI) == "declare -a"* ]]; then
		repos=( "${EGIT_REPO_URI[@]}" )
	else
		repos=( ${EGIT_REPO_URI} )
	fi

	[[ ${repos[@]} ]] || die "No URI provided and EGIT_REPO_URI unset"

	local r
	for r in "${repos[@]}"; do
		if [[ ${r} == git:* || ${r} == http:* ]]; then
			ewarn "git-r3: ${r%%:*} protocol is completely insecure and may render the ebuild"
			ewarn "easily susceptible to MITM attacks (even if used only as fallback). Please"
			ewarn "use https instead."
			ewarn "[URI: ${r}]"
		fi
	done

	local -x GIT_DIR
	_git-r3_set_gitdir "${repos[0]}"

	einfo "Repository id: ${GIT_DIR##*/}"

	# prepend the local mirror if applicable
	if [[ ${EGIT_MIRROR_URI} ]]; then
		repos=(
			"${EGIT_MIRROR_URI%/}/${GIT_DIR##*/}"
			"${repos[@]}"
		)
	fi

	# get the default values for the common variables and override them
	local branch_name=${EGIT_BRANCH}
	local commit_id=${2:-${EGIT_COMMIT}}
	local commit_date=${4:-${EGIT_COMMIT_DATE}}

	# get the name and do some more processing:
	# 1) kill .git suffix,
	# 2) underscore (remaining) non-variable characters,
	# 3) add preceding underscore if it starts with a digit,
	# 4) uppercase.
	local override_name=${GIT_DIR##*/}
	override_name=${override_name%.git}
	override_name=${override_name//[^a-zA-Z0-9_]/_}
	override_name=${override_name^^}

	local varmap=(
		REPO:repos
		BRANCH:branch_name
		COMMIT:commit_id
		COMMIT_DATE:commit_date
	)

	local localvar livevar live_warn= override_vars=()
	for localvar in "${varmap[@]}"; do
		livevar=EGIT_OVERRIDE_${localvar%:*}_${override_name}
		localvar=${localvar#*:}
		override_vars+=( "${livevar}" )

		if [[ -n ${!livevar} ]]; then
			[[ ${localvar} == repos ]] && repos=()
			live_warn=1
			ewarn "Using ${livevar}=${!livevar}"
			declare "${localvar}=${!livevar}"
		fi
	done

	if [[ ${live_warn} ]]; then
		ewarn "No support will be provided."
	else
		einfo "To override fetched repository properties, use:"
		local x
		for x in "${override_vars[@]}"; do
			einfo "  ${x}"
		done
		einfo
	fi

	# set final variables after applying overrides
	local branch=${branch_name:+refs/heads/${branch_name}}
	local remote_ref=${commit_id:-${branch:-HEAD}}
	local local_id=${3:-${CATEGORY}/${PN}/${SLOT%/*}}
	local local_ref=refs/git-r3/${local_id}/__main__

	# try to fetch from the remote
	local success saved_umask
	if [[ ${EVCS_UMASK} ]]; then
		saved_umask=$(umask)
		umask "${EVCS_UMASK}" || die "Bad options to umask: ${EVCS_UMASK}"
	fi
	for r in "${repos[@]}"; do
		if [[ ! ${EVCS_OFFLINE} ]]; then
			einfo "Fetching ${r} ..."

			local fetch_command=( git fetch "${r}" )
			local clone_type=${EGIT_CLONE_TYPE}

			if [[ ${clone_type} == mirror ]]; then
				fetch_command+=(
					--prune
					# mirror the remote branches as local branches
					"+refs/heads/*:refs/heads/*"
					# pull tags explicitly in order to prune them properly
					"+refs/tags/*:refs/tags/*"
					# notes in case something needs them
					"+refs/notes/*:refs/notes/*"
					# pullrequest refs are useful for testing incoming changes
					"+refs/pull/*/head:refs/pull/*"
					# and HEAD in case we need the default branch
					# (we keep it in refs/git-r3 since otherwise --prune interferes)
					"+HEAD:refs/git-r3/HEAD"
					# fetch the specifc commit_ref to deal with orphan commits
					"${remote_ref}"
				)
			else # single or shallow
				local fetch_l fetch_r

				if [[ ${remote_ref} == HEAD ]]; then
					# HEAD
					fetch_l=HEAD
				elif [[ ${remote_ref} == refs/* ]]; then
					# regular branch, tag or some other explicit ref
					fetch_l=${remote_ref}
				else
					# tag or commit id...
					# let ls-remote figure it out
					local tagref=$(git ls-remote "${r}" "refs/tags/${remote_ref}")

					# if it was a tag, ls-remote obtained a hash
					if [[ ${tagref} ]]; then
						# tag
						fetch_l=refs/tags/${remote_ref}
					else
						# commit id
						# so we need to fetch the whole branch
						if [[ ${branch} ]]; then
							fetch_l=${branch}
						else
							fetch_l=HEAD
						fi

						# fetching by commit in shallow mode? can't do.
						if [[ ${clone_type} == shallow ]]; then
							clone_type=single
						fi
					fi
				fi

				# checkout by date does not make sense in shallow mode
				if [[ ${commit_date} && ${clone_type} == shallow ]]; then
					clone_type=single
				fi

				if [[ ${fetch_l} == HEAD ]]; then
					fetch_r=refs/git-r3/HEAD
				else
					fetch_r=${fetch_l}
				fi

				fetch_command+=(
					"+${fetch_l}:${fetch_r}"
				)

				if [[ ${clone_type} == single+tags ]]; then
					fetch_command+=(
						# pull tags explicitly as requested
						"+refs/tags/*:refs/tags/*"
					)
				fi
			fi

			if [[ ${clone_type} == shallow ]]; then
				if _git-r3_is_local_repo; then
					# '--depth 1' causes sandbox violations with local repos
					# bug #491260
					clone_type=single
				elif [[ ! $(git rev-parse --quiet --verify "${fetch_r}") ]]
				then
					# use '--depth 1' when fetching a new branch
					fetch_command+=( --depth 1 )
				fi
			else # non-shallow mode
				if [[ -f ${GIT_DIR}/shallow ]]; then
					fetch_command+=( --unshallow )
				fi
			fi

			set -- "${fetch_command[@]}"
			echo "${@}" >&2
			"${@}" || continue

			if [[ ${clone_type} == mirror || ${fetch_l} == HEAD ]]; then
				# update our HEAD to match our remote HEAD ref
				git symbolic-ref HEAD refs/git-r3/HEAD \
						|| die "Unable to update HEAD"
			fi
		fi

		# now let's see what the user wants from us
		if [[ ${commit_date} ]]; then
			local dated_commit_id=$(
				git rev-list --first-parent --before="${commit_date}" \
					-n 1 "${remote_ref}"
			)
			if [[ ${?} -ne 0 ]]; then
				die "Listing ${remote_ref} failed (wrong ref?)."
			elif [[ ! ${dated_commit_id} ]]; then
				die "Unable to find commit for date ${commit_date}."
			else
				set -- git update-ref --no-deref "${local_ref}" "${dated_commit_id}"
			fi
		else
			local full_remote_ref=$(
				git rev-parse --verify --symbolic-full-name "${remote_ref}"
			)

			if [[ ${full_remote_ref} ]]; then
				# when we are given a ref, create a symbolic ref
				# so that we preserve the actual argument
				set -- git symbolic-ref "${local_ref}" "${full_remote_ref}"
			else
				# otherwise, we were likely given a commit id
				set -- git update-ref --no-deref "${local_ref}" "${remote_ref}"
			fi
		fi

		echo "${@}" >&2
		if ! "${@}"; then
			if [[ ${EVCS_OFFLINE} ]]; then
				eerror "A clone of the following repository is required to proceed:"
				eerror "  ${r}"
				eerror "However, networking activity has been disabled using EVCS_OFFLINE and the local"
				eerror "clone does not have requested ref:"
				eerror "  ${remote_ref}"
				die "Local clone of ${r} does not have requested ref: ${remote_ref}. Unable to proceed with EVCS_OFFLINE."
			else
				die "Referencing ${remote_ref} failed (wrong ref?)."
			fi
		fi

		if [[ ${EGIT_LFS} ]]; then
			# Fetch the LFS files from the current ref (if any)
			local lfs_fetch_command=( git lfs fetch "${r}" )

			case "${EGIT_LFS_CLONE_TYPE}" in
				shallow)
					lfs_fetch_command+=(
						--prune
					)
					;;
				single)
					;;
				mirror)
					lfs_fetch_command+=(
						--all
					)
					;;
				*)
					die "Invalid EGIT_LFS_CLONE_TYPE=${EGIT_LFS_CLONE_TYPE}"
			esac

			set -- "${lfs_fetch_command[@]}"
			echo "${@}" >&2
			"${@}" || die
		elif [[ -d ${GIT_DIR}/lfs && ${EGIT_LFS_CLONE_TYPE} == shallow ]]; then
			# Cleanup the LFS files from old checkouts if LFS support has been turned off.
			rm -fr ${GIT_DIR}/lfs || die
		fi

		success=1
		break
	done
	if [[ ${saved_umask} ]]; then
		umask "${saved_umask}" || die
	fi
	[[ ${success} ]] || die "Unable to fetch from any of EGIT_REPO_URI"

	# submodules can reference commits in any branch
	# always use the 'mirror' mode to accommodate that, bug #503332
	local EGIT_CLONE_TYPE=mirror

	# recursively fetch submodules
	if git cat-file -e "${local_ref}":.gitmodules &>/dev/null; then
		local submodules
		_git-r3_set_submodules "${_GIT_SUBMODULE_PATH}" \
			"$(git cat-file -p "${local_ref}":.gitmodules || die)"

		while [[ ${submodules[@]} ]]; do
			local subname=${submodules[0]}
			local url=${submodules[1]}
			local path=${submodules[2]}

			# use only submodules for which path does exist
			# (this is in par with 'git submodule'), bug #551100
			# note: git cat-file does not work for submodules
			if [[ $(git ls-tree -d "${local_ref}" "${path}") ]]
			then
				local commit=$(git rev-parse "${local_ref}:${path}" || die)

				if [[ ! ${commit} ]]; then
					die "Unable to get commit id for submodule ${subname}"
				fi

				local subrepos
				_git-r3_set_subrepos "${url}" "${repos[@]}"

				_GIT_SUBMODULE_PATH=${_GIT_SUBMODULE_PATH}${path}/ \
				git-r3_fetch "${subrepos[*]}" "${commit}" \
					"${local_id}/${subname}" ""
			fi

			submodules=( "${submodules[@]:3}" ) # shift
		done
	fi
}

# @FUNCTION: git-r3_checkout
# @USAGE: [<repo-uri> [<checkout-path> [<local-id> [<checkout-paths>...]]]]
# @DESCRIPTION:
# Check the previously fetched tree to the working copy.
#
# <repo-uri> specifies the repository URIs, as a space-separated list.
# The first URI will be used as repository group identifier
# and therefore must be used consistently with git-r3_fetch.
# The remaining URIs are not used and therefore may be omitted.
# When not specified, defaults to ${EGIT_REPO_URI}.
#
# <checkout-path> specifies the path to place the checkout. It defaults
# to ${EGIT_CHECKOUT_DIR} if set, otherwise to ${WORKDIR}/${P}.
#
# <local-id> needs to specify the local identifier that was used
# for respective git-r3_fetch.
#
# If <checkout-paths> are specified, then the specified paths are passed
# to 'git checkout' to effect a partial checkout. Please note that such
# checkout will not cause the repository to switch branches,
# and submodules will be skipped at the moment. The submodules matching
# those paths might be checked out in a future version of the eclass.
#
# The checkout operation will write to the working copy, and export
# the repository state into the environment. If the repository contains
# submodules, they will be checked out recursively.
git-r3_checkout() {
	debug-print-function ${FUNCNAME} "$@"

	local repos
	if [[ ${1} ]]; then
		repos=( ${1} )
	elif [[ $(declare -p EGIT_REPO_URI) == "declare -a"* ]]; then
		repos=( "${EGIT_REPO_URI[@]}" )
	else
		repos=( ${EGIT_REPO_URI} )
	fi

	local out_dir=${2:-${EGIT_CHECKOUT_DIR:-${WORKDIR}/${P}}}
	local local_id=${3:-${CATEGORY}/${PN}/${SLOT%/*}}
	local checkout_paths=( "${@:4}" )

	local -x GIT_DIR
	_git-r3_set_gitdir "${repos[0]}"

	einfo "Checking out ${repos[0]} to ${out_dir} ..."

	if ! git cat-file -e refs/git-r3/"${local_id}"/__main__; then
		die "Logic error: no local clone of ${repos[0]}. git-r3_fetch not used?"
	fi
	local remote_ref=$(
		git symbolic-ref --quiet refs/git-r3/"${local_id}"/__main__
	)
	local new_commit_id=$(
		git rev-parse --verify refs/git-r3/"${local_id}"/__main__
	)

	git-r3_sub_checkout() {
		local orig_repo=${GIT_DIR}
		local -x GIT_DIR=${out_dir}/.git
		local -x GIT_WORK_TREE=${out_dir}

		mkdir -p "${out_dir}" || die

		# use git init+fetch instead of clone since the latter doesn't like
		# non-empty directories.

		git init --quiet -b __init__ || die
		if [[ ${EGIT_LFS} ]]; then
			# The "skip-repo" flag will just skip the installation of the pre-push hooks.
			# We don't use these hook as we don't do any pushes
			git lfs install --local --skip-repo || die
		fi
		# setup 'alternates' to avoid copying objects
		echo "${orig_repo}/objects" > "${GIT_DIR}"/objects/info/alternates || die
		# now copy the refs
		cp -R "${orig_repo}"/refs/* "${GIT_DIR}"/refs/ || die
		if [[ -f ${orig_repo}/packed-refs ]]; then
			cp "${orig_repo}"/packed-refs "${GIT_DIR}"/packed-refs || die
		fi

		# mark this directory as "safe" so that src_install() can access it
		# https://bugs.gentoo.org/879353
		git config --global --add safe.directory \
			"$(cd "${out_dir}" && echo "${PWD}")" || die

		# (no need to copy HEAD, we will set it via checkout)

		if [[ -f ${orig_repo}/shallow ]]; then
			cp "${orig_repo}"/shallow "${GIT_DIR}"/ || die
		fi

		set -- git checkout --quiet
		if [[ ${remote_ref} ]]; then
			set -- "${@}" "${remote_ref#refs/heads/}"
		else
			set -- "${@}" "${new_commit_id}"
		fi
		if [[ ${checkout_paths[@]} ]]; then
			set -- "${@}" -- "${checkout_paths[@]}"
		fi
		echo "${@}" >&2
		"${@}" || die "git checkout ${remote_ref:-${new_commit_id}} failed"

		# If any filters in any of the ".gitattributes" files specifies lfs,
		# then this repo is most likely storing files with git lfs.
		local has_git_lfs_filters=$(
			git grep "filter=lfs" -- ".gitattributes" "**/.gitattributes"
		)
		if [[ $has_git_lfs_filters ]]; then
			# This is used for issuing QA warnings regarding LFS files in the repo (or lack thereof)
			_EGIT_LFS_FILTERS_FOUND="yes"
		fi
	}
	git-r3_sub_checkout
	unset -f git-r3_sub_checkout

	local old_commit_id=$(
		git rev-parse --quiet --verify refs/git-r3/"${local_id}"/__old__
	)
	if [[ ! ${old_commit_id} ]]; then
		echo "GIT NEW branch -->"
		echo "   repository:               ${repos[0]}"
		echo "   at the commit:            ${new_commit_id}"
	else
		# diff against previous revision
		echo "GIT update -->"
		echo "   repository:               ${repos[0]}"
		# write out message based on the revisions
		if [[ "${old_commit_id}" != "${new_commit_id}" ]]; then
			echo "   updating from commit:     ${old_commit_id}"
			echo "   to commit:                ${new_commit_id}"

			set -- git --no-pager diff --stat \
				${old_commit_id}..${new_commit_id}
			if [[ ${checkout_paths[@]} ]]; then
				set -- "${@}" -- "${checkout_paths[@]}"
			fi
			"${@}"
		else
			echo "   at the commit:            ${new_commit_id}"
		fi
	fi
	git update-ref --no-deref refs/git-r3/"${local_id}"/{__old__,__main__} || die

	# recursively checkout submodules
	if [[ -f ${out_dir}/.gitmodules && ! ${checkout_paths} ]]; then
		local submodules
		_git-r3_set_submodules "${_GIT_SUBMODULE_PATH}" \
			"$(<"${out_dir}"/.gitmodules)"

		while [[ ${submodules[@]} ]]; do
			local subname=${submodules[0]}
			local url=${submodules[1]}
			local path=${submodules[2]}

			# use only submodules for which path does exist
			# (this is in par with 'git submodule'), bug #551100
			if [[ -d ${out_dir}/${path} ]]; then
				local subrepos
				_git-r3_set_subrepos "${url}" "${repos[@]}"

				_GIT_SUBMODULE_PATH=${_GIT_SUBMODULE_PATH}${path}/ \
				git-r3_checkout "${subrepos[*]}" "${out_dir}/${path}" \
					"${local_id}/${subname}"
			fi

			submodules=( "${submodules[@]:3}" ) # shift
		done
	fi

	# keep this *after* submodules
	export EGIT_DIR=${GIT_DIR}
	export EGIT_VERSION=${new_commit_id}
}

# @FUNCTION: git-r3_peek_remote_ref
# @USAGE: [<repo-uri> [<remote-ref>]]
# @DESCRIPTION:
# Peek the reference in the remote repository and print the matching
# (newest) commit SHA1.
#
# <repo-uri> specifies the repository URIs to fetch from, as a space-
# -separated list. When not specified, defaults to ${EGIT_REPO_URI}.
#
# <remote-ref> specifies the remote ref to peek.  It is preferred to use
# 'refs/heads/<branch-name>' for branches and 'refs/tags/<tag-name>'
# for tags. Alternatively, 'HEAD' may be used for upstream default
# branch. Defaults to the first of EGIT_COMMIT, EGIT_BRANCH or literal
# 'HEAD' that is set to a non-null value.
#
# The operation will be done purely on the remote, without using local
# storage. If commit SHA1 is provided as <remote-ref>, the function will
# fail due to limitations of git protocol.
#
# On success, the function returns 0 and writes hexadecimal commit SHA1
# to stdout. On failure, the function returns 1.
git-r3_peek_remote_ref() {
	debug-print-function ${FUNCNAME} "$@"

	local repos
	if [[ ${1} ]]; then
		repos=( ${1} )
	elif [[ $(declare -p EGIT_REPO_URI) == "declare -a"* ]]; then
		repos=( "${EGIT_REPO_URI[@]}" )
	else
		repos=( ${EGIT_REPO_URI} )
	fi

	local branch=${EGIT_BRANCH:+refs/heads/${EGIT_BRANCH}}
	local remote_ref=${2:-${EGIT_COMMIT:-${branch:-HEAD}}}

	[[ ${repos[@]} ]] || die "No URI provided and EGIT_REPO_URI unset"

	local r success
	for r in "${repos[@]}"; do
		einfo "Peeking ${remote_ref} on ${r} ..." >&2

		local lookup_ref
		if [[ ${remote_ref} == refs/* || ${remote_ref} == HEAD ]]
		then
			lookup_ref=${remote_ref}
		else
			# ls-remote by commit is going to fail anyway,
			# so we may as well pass refs/tags/ABCDEF...
			lookup_ref=refs/tags/${remote_ref}
		fi

		# split on whitespace
		local ref=(
			$(git ls-remote "${r}" "${lookup_ref}")
		)

		if [[ ${ref[0]} ]]; then
			echo "${ref[0]}"
			return 0
		fi
	done

	return 1
}

git-r3_src_fetch() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ! ${EGIT3_STORE_DIR} && ${EGIT_STORE_DIR} ]]; then
		ewarn "You have set EGIT_STORE_DIR but not EGIT3_STORE_DIR. Please consider"
		ewarn "setting EGIT3_STORE_DIR for git-r3.eclass. It is recommended to use"
		ewarn "a different directory than EGIT_STORE_DIR to ease removing old clones"
		ewarn "when git-2 eclass becomes deprecated."
	fi

	_git-r3_env_setup
	git-r3_fetch
}

git-r3_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	_git-r3_env_setup
	git-r3_src_fetch
	git-r3_checkout

	if [[ ! ${EGIT_LFS} && ${_EGIT_LFS_FILTERS_FOUND} ]]; then
		eqawarn "QA Notice: There are Git LFS filters setup in the cloned repo, consider using EGIT_LFS!"
	fi
	if [[ ${EGIT_LFS} && ! ${_EGIT_LFS_FILTERS_FOUND} ]]; then
		eqawarn "QA Notice: There are no Git LFS filters setup in the cloned repo. EGIT_LFS will do nothing!"
	fi
}

# https://bugs.gentoo.org/show_bug.cgi?id=482666
git-r3_pkg_needrebuild() {
	debug-print-function ${FUNCNAME} "$@"

	local new_commit_id=$(git-r3_peek_remote_ref)
	[[ ${new_commit_id} && ${EGIT_VERSION} ]] || die "Lookup failed"

	if [[ ${EGIT_VERSION} != ${new_commit_id} ]]; then
		einfo "Update from ${EGIT_VERSION} to ${new_commit_id}"
	else
		einfo "Local and remote at ${EGIT_VERSION}"
	fi

	[[ ${EGIT_VERSION} != ${new_commit_id} ]]
}

# 'export' locally until this gets into EAPI
pkg_needrebuild() { git-r3_pkg_needrebuild; }

fi

EXPORT_FUNCTIONS src_unpack
