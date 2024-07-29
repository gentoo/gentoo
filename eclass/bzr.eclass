# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# @ECLASS: bzr.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
# Mark Lee <bzr-gentoo-overlay@lazymalevolence.com>
# Ulrich Müller <ulm@gentoo.org>
# Christian Faulhammer <fauli@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: generic fetching functions for the Bazaar VCS
# @DESCRIPTION:
# The bzr.eclass provides functions to fetch and unpack sources from
# repositories of the Bazaar distributed version control system.
# The eclass was originally derived from git.eclass.
#
# Note: Just set EBZR_REPO_URI to the URI of the branch and src_unpack()
# of this eclass will export the branch to ${WORKDIR}/${P}.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

PROPERTIES+=" live"

BDEPEND="dev-vcs/breezy"

# @ECLASS_VARIABLE: EBZR_STORE_DIR
# @USER_VARIABLE
# @DESCRIPTION:
# The directory to store all fetched Bazaar live sources.
: "${EBZR_STORE_DIR:=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/bzr-src}"

# @ECLASS_VARIABLE: EBZR_UNPACK_DIR
# @DESCRIPTION:
# The working directory where the sources are copied to.
: "${EBZR_UNPACK_DIR:=${WORKDIR}/${P}}"

# @ECLASS_VARIABLE: EBZR_INIT_REPO_CMD
# @DESCRIPTION:
# The Bazaar command to initialise a shared repository.
: "${EBZR_INIT_REPO_CMD:="brz init-shared-repository --no-trees"}"

# @ECLASS_VARIABLE: EBZR_FETCH_CMD
# @DESCRIPTION:
# The Bazaar command to fetch the sources.
: "${EBZR_FETCH_CMD:="brz branch --no-tree"}"

# @ECLASS_VARIABLE: EBZR_UPDATE_CMD
# @DESCRIPTION:
# The Bazaar command to update the sources.
: "${EBZR_UPDATE_CMD:="brz pull --overwrite-tags"}"

# @ECLASS_VARIABLE: EBZR_EXPORT_CMD
# @DESCRIPTION:
# The Bazaar command to export a branch.
: "${EBZR_EXPORT_CMD:="brz export"}"

# @ECLASS_VARIABLE: EBZR_CHECKOUT_CMD
# @DESCRIPTION:
# The Bazaar command to checkout a branch.
: "${EBZR_CHECKOUT_CMD:="brz checkout --lightweight -q"}"

# @ECLASS_VARIABLE: EBZR_REVNO_CMD
# @DESCRIPTION:
# The Bazaar command to list a revision number of the branch.
: "${EBZR_REVNO_CMD:="brz revno"}"

# @ECLASS_VARIABLE: EBZR_OPTIONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The options passed to the fetch and update commands.

# @ECLASS_VARIABLE: EBZR_REPO_URI
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# The repository URI for the source package.

# @ECLASS_VARIABLE: EBZR_PROJECT
# @DESCRIPTION:
# The project name of your ebuild.  Normally, the branch will be stored
# in the ${EBZR_STORE_DIR}/${EBZR_PROJECT} directory.
#
# If EBZR_BRANCH is set (see below), then a shared repository will be
# created in that directory, and the branch will be located in
# ${EBZR_STORE_DIR}/${EBZR_PROJECT}/${EBZR_BRANCH}.
: "${EBZR_PROJECT:=${PN}}"

# @ECLASS_VARIABLE: EBZR_BRANCH
# @DEFAULT_UNSET
# @DESCRIPTION:
# The directory where to store the branch within a shared repository,
# relative to ${EBZR_STORE_DIR}/${EBZR_PROJECT}.
#
# This variable should be set if there are several live ebuilds for
# different branches of the same upstream project.  The branches can
# then share the same repository in EBZR_PROJECT, which will save both
# data traffic volume and disk space.
#
# If there is only a live ebuild for one single branch, EBZR_BRANCH
# needs not be set.  In this case, the branch will be stored in a
# stand-alone repository directly in EBZR_PROJECT.

# @ECLASS_VARIABLE: EBZR_REVISION
# @DEFAULT_UNSET
# @DESCRIPTION:
# Revision to fetch, defaults to the latest (see brz help revisionspec).

# @ECLASS_VARIABLE: EBZR_OFFLINE
# @USER_VARIABLE
# @DESCRIPTION:
# Set this variable to a non-empty value to disable automatic updating
# of a bzr source tree.  This is intended to be set outside the ebuild
# by users.
: "${EBZR_OFFLINE=${EVCS_OFFLINE}}"

# @ECLASS_VARIABLE: EVCS_UMASK
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable to a custom umask.  This is intended to be set by
# users.  By setting this to something like 002, it can make life easier
# for people who do development as non-root (but are in the portage
# group), and then switch over to building with FEATURES=userpriv.
# Or vice-versa.  Shouldn't be a security issue here as anyone who has
# portage group write access already can screw the system over in more
# creative ways.

# @ECLASS_VARIABLE: EBZR_WORKDIR_CHECKOUT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If this variable is set to a non-empty value, EBZR_CHECKOUT_CMD will
# be used instead of EBZR_EXPORT_CMD to copy the sources to WORKDIR.

# @FUNCTION: _bzr_initial_fetch
# @USAGE: <repository URI> <branch directory>
# @INTERNAL
# @DESCRIPTION:
# Internal function, retrieves the source code from a repository for the
# first time, using ${EBZR_FETCH_CMD}.
_bzr_initial_fetch() {
	local repo_uri=$1 branch_dir=$2

	if [[ -n ${EBZR_OFFLINE} ]]; then
		die "EBZR_OFFLINE cannot be used when there is no local branch yet."
	fi

	# fetch branch
	einfo "bzr branch start -->"
	einfo "   repository: ${repo_uri} => ${branch_dir}"

	${EBZR_FETCH_CMD} ${EBZR_OPTIONS} "${repo_uri}" "${branch_dir}" \
		|| die "${ECLASS}: can't branch from ${repo_uri}"
}

# @FUNCTION: _bzr_update
# @USAGE: <repository URI> <branch directory>
# @INTERNAL
# @DESCRIPTION:
# Internal function, updates the source code from a repository, using
# ${EBZR_UPDATE_CMD}.
_bzr_update() {
	local repo_uri=$1 branch_dir=$2

	if [[ -n ${EBZR_OFFLINE} ]]; then
		einfo "skipping bzr pull -->"
		einfo "   repository: ${repo_uri}"
	else
		# update branch
		einfo "bzr pull start -->"
		einfo "   repository: ${repo_uri}"

		pushd "${branch_dir}" > /dev/null \
			|| die "${ECLASS}: can't chdir to ${branch_dir}"
		${EBZR_UPDATE_CMD} ${EBZR_OPTIONS} "${repo_uri}" \
			|| die "${ECLASS}: can't pull from ${repo_uri}"
		popd > /dev/null || die "${ECLASS}: popd failed"
	fi
}

# @FUNCTION: bzr_fetch
# @DESCRIPTION:
# Wrapper function to fetch sources from a Bazaar repository with
# bzr branch or bzr pull, depending on whether there is an existing
# working copy.
bzr_fetch() {
	local repo_dir branch_dir save_umask

	[[ -n ${EBZR_REPO_URI} ]] || die "${ECLASS}: EBZR_REPO_URI is empty"

	if [[ ! -d ${EBZR_STORE_DIR} ]]; then
		(
			addwrite /
			mkdir -p "${EBZR_STORE_DIR}" \
				|| die "${ECLASS}: can't mkdir ${EBZR_STORE_DIR}"
		)
	fi

	pushd "${EBZR_STORE_DIR}" > /dev/null \
		|| die "${ECLASS}: can't chdir to ${EBZR_STORE_DIR}"

	repo_dir=${EBZR_STORE_DIR}/${EBZR_PROJECT}
	branch_dir=${repo_dir}${EBZR_BRANCH:+/${EBZR_BRANCH}}

	if [[ -n ${EVCS_UMASK} ]]; then
		save_umask=$(umask) || die
		umask "${EVCS_UMASK}" || die
	fi
	addwrite "${EBZR_STORE_DIR}"

	if [[ ! -d ${branch_dir}/.bzr ]]; then
		if [[ ${repo_dir} != "${branch_dir}" && ! -d ${repo_dir}/.bzr ]]; then
			einfo "creating shared bzr repository: ${repo_dir}"
			${EBZR_INIT_REPO_CMD} "${repo_dir}" \
				|| die "${ECLASS}: can't create shared repository"
		fi
		_bzr_initial_fetch "${EBZR_REPO_URI}" "${branch_dir}"
	else
		_bzr_update "${EBZR_REPO_URI}" "${branch_dir}"
	fi

	if [[ -n ${save_umask} ]]; then
		umask "${save_umask}" || die
	fi

	cd "${branch_dir}" || die "${ECLASS}: can't chdir to ${branch_dir}"

	# Save revision number in environment. #311101
	export EBZR_REVNO=$(${EBZR_REVNO_CMD})

	if [[ -n ${EBZR_WORKDIR_CHECKOUT} ]]; then
		einfo "checking out ..."
		${EBZR_CHECKOUT_CMD} ${EBZR_REVISION:+-r ${EBZR_REVISION}} \
			. "${EBZR_UNPACK_DIR}" || die "${ECLASS}: checkout failed"
	else
		einfo "exporting ..."
		${EBZR_EXPORT_CMD} ${EBZR_REVISION:+-r ${EBZR_REVISION}} \
			"${EBZR_UNPACK_DIR}" . || die "${ECLASS}: export failed"
	fi
	einfo \
		"revision ${EBZR_REVISION:-${EBZR_REVNO}} is now in ${EBZR_UNPACK_DIR}"

	popd > /dev/null || die "${ECLASS}: popd failed"
}

# @FUNCTION: bzr_src_unpack
# @DESCRIPTION:
# Default src_unpack(), calls bzr_fetch.
bzr_src_unpack() {
	bzr_fetch
}

EXPORT_FUNCTIONS src_unpack
