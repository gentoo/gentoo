# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bzr.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
# Mark Lee <bzr-gentoo-overlay@lazymalevolence.com>
# Ulrich Müller <ulm@gentoo.org>
# Christian Faulhammer <fauli@gentoo.org>
# @SUPPORTED_EAPIS: 2 3 4 5 6 7
# @BLURB: generic fetching functions for the Bazaar VCS
# @DESCRIPTION:
# The bzr.eclass provides functions to fetch and unpack sources from
# repositories of the Bazaar distributed version control system.
# The eclass was originally derived from git.eclass.
#
# Note: Just set EBZR_REPO_URI to the URI of the branch and src_unpack()
# of this eclass will export the branch to ${WORKDIR}/${P}.

EBZR="bzr.eclass"

PROPERTIES+=" live"

if [[ ${EBZR_REPO_URI%%:*} = sftp ]]; then
	DEPEND=">=dev-vcs/bzr-2.6.0[sftp]"
else
	DEPEND=">=dev-vcs/bzr-2.6.0"
fi

case ${EAPI:-0} in
	2|3|4|5|6) ;;
	7) BDEPEND="${DEPEND}"; DEPEND="" ;;
	*) die "${EBZR}: EAPI ${EAPI:-0} is not supported" ;;
esac

EXPORT_FUNCTIONS src_unpack

# @ECLASS-VARIABLE: EBZR_STORE_DIR
# @DESCRIPTION:
# The directory to store all fetched Bazaar live sources.
: ${EBZR_STORE_DIR:=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/bzr-src}

# @ECLASS-VARIABLE: EBZR_UNPACK_DIR
# @DESCRIPTION:
# The working directory where the sources are copied to.
: ${EBZR_UNPACK_DIR:=${WORKDIR}/${P}}

# @ECLASS-VARIABLE: EBZR_INIT_REPO_CMD
# @DESCRIPTION:
# The Bazaar command to initialise a shared repository.
: ${EBZR_INIT_REPO_CMD:="bzr init-repository --no-trees"}

# @ECLASS-VARIABLE: EBZR_FETCH_CMD
# @DESCRIPTION:
# The Bazaar command to fetch the sources.
: ${EBZR_FETCH_CMD:="bzr branch --no-tree"}

# @ECLASS-VARIABLE: EBZR_UPDATE_CMD
# @DESCRIPTION:
# The Bazaar command to update the sources.
: ${EBZR_UPDATE_CMD:="bzr pull --overwrite-tags"}

# @ECLASS-VARIABLE: EBZR_EXPORT_CMD
# @DESCRIPTION:
# The Bazaar command to export a branch.
: ${EBZR_EXPORT_CMD:="bzr export"}

# @ECLASS-VARIABLE: EBZR_CHECKOUT_CMD
# @DESCRIPTION:
# The Bazaar command to checkout a branch.
: ${EBZR_CHECKOUT_CMD:="bzr checkout --lightweight -q"}

# @ECLASS-VARIABLE: EBZR_REVNO_CMD
# @DESCRIPTION:
# The Bazaar command to list a revision number of the branch.
: ${EBZR_REVNO_CMD:="bzr revno"}

# @ECLASS-VARIABLE: EBZR_OPTIONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The options passed to the fetch and update commands.

# @ECLASS-VARIABLE: EBZR_REPO_URI
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# The repository URI for the source package.
#
# Note: If the ebuild uses an sftp:// URI, then the eclass will depend
# on dev-vcs/bzr[sftp].

# @ECLASS-VARIABLE: EBZR_INITIAL_URI
# @DEFAULT_UNSET
# @DESCRIPTION:
# The URI used for initial branching of the source repository.  If this
# variable is set, the initial branch will be cloned from the location
# specified, followed by a pull from ${EBZR_REPO_URI}.  This is intended
# for special cases, e.g. when download from the original repository is
# slow, but a fast mirror exists but may be out of date.
#
# Normally, this variable needs not be set.

# @ECLASS-VARIABLE: EBZR_PROJECT
# @DESCRIPTION:
# The project name of your ebuild.  Normally, the branch will be stored
# in the ${EBZR_STORE_DIR}/${EBZR_PROJECT} directory.
#
# If EBZR_BRANCH is set (see below), then a shared repository will be
# created in that directory, and the branch will be located in
# ${EBZR_STORE_DIR}/${EBZR_PROJECT}/${EBZR_BRANCH}.
: ${EBZR_PROJECT:=${PN}}

# @ECLASS-VARIABLE: EBZR_BRANCH
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

# @ECLASS-VARIABLE: EBZR_REVISION
# @DEFAULT_UNSET
# @DESCRIPTION:
# Revision to fetch, defaults to the latest
# (see http://bazaar-vcs.org/BzrRevisionSpec or bzr help revisionspec).

# @ECLASS-VARIABLE: EBZR_OFFLINE
# @DESCRIPTION:
# Set this variable to a non-empty value to disable automatic updating
# of a bzr source tree.  This is intended to be set outside the ebuild
# by users.
: ${EBZR_OFFLINE=${EVCS_OFFLINE}}

# @ECLASS-VARIABLE: EVCS_UMASK
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable to a custom umask.  This is intended to be set by
# users.  By setting this to something like 002, it can make life easier
# for people who do development as non-root (but are in the portage
# group), and then switch over to building with FEATURES=userpriv.
# Or vice-versa.  Shouldn't be a security issue here as anyone who has
# portage group write access already can screw the system over in more
# creative ways.

# @ECLASS-VARIABLE: EBZR_WORKDIR_CHECKOUT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If this variable is set to a non-empty value, EBZR_CHECKOUT_CMD will
# be used instead of EBZR_EXPORT_CMD to copy the sources to WORKDIR.

# @FUNCTION: bzr_initial_fetch
# @USAGE: <repository URI> <branch directory>
# @DESCRIPTION:
# Internal function, retrieves the source code from a repository for the
# first time, using ${EBZR_FETCH_CMD}.
bzr_initial_fetch() {
	local repo_uri=$1 branch_dir=$2

	if [[ -n "${EBZR_OFFLINE}" ]]; then
		ewarn "EBZR_OFFLINE cannot be used when there is no local branch yet."
	fi

	# fetch branch
	einfo "bzr branch start -->"
	einfo "   repository: ${repo_uri} => ${branch_dir}"

	${EBZR_FETCH_CMD} ${EBZR_OPTIONS} "${repo_uri}" "${branch_dir}" \
		|| die "${EBZR}: can't branch from ${repo_uri}"
}

# @FUNCTION: bzr_update
# @USAGE: <repository URI> <branch directory>
# @DESCRIPTION:
# Internal function, updates the source code from a repository, using
# ${EBZR_UPDATE_CMD}.
bzr_update() {
	local repo_uri=$1 branch_dir=$2

	if [[ -n "${EBZR_OFFLINE}" ]]; then
		einfo "skipping bzr pull -->"
		einfo "   repository: ${repo_uri}"
	else
		# update branch
		einfo "bzr pull start -->"
		einfo "   repository: ${repo_uri}"

		pushd "${branch_dir}" > /dev/null \
			|| die "${EBZR}: can't chdir to ${branch_dir}"
		${EBZR_UPDATE_CMD} ${EBZR_OPTIONS} "${repo_uri}" \
			|| die "${EBZR}: can't pull from ${repo_uri}"
		popd > /dev/null || die "${EBZR}: popd failed"
	fi
}

# @FUNCTION: bzr_fetch
# @DESCRIPTION:
# Wrapper function to fetch sources from a Bazaar repository with
# bzr branch or bzr pull, depending on whether there is an existing
# working copy.
bzr_fetch() {
	local repo_dir branch_dir
	local save_sandbox_write=${SANDBOX_WRITE} save_umask

	[[ -n ${EBZR_REPO_URI} ]] || die "${EBZR}: EBZR_REPO_URI is empty"

	if [[ ! -d ${EBZR_STORE_DIR} ]] ; then
		addwrite /
		mkdir -p "${EBZR_STORE_DIR}" \
			|| die "${EBZR}: can't mkdir ${EBZR_STORE_DIR}"
		SANDBOX_WRITE=${save_sandbox_write}
	fi

	pushd "${EBZR_STORE_DIR}" > /dev/null \
		|| die "${EBZR}: can't chdir to ${EBZR_STORE_DIR}"

	repo_dir=${EBZR_STORE_DIR}/${EBZR_PROJECT}
	branch_dir=${repo_dir}${EBZR_BRANCH:+/${EBZR_BRANCH}}

	if [[ -n ${EVCS_UMASK} ]]; then
		save_umask=$(umask)
		umask "${EVCS_UMASK}" || die
	fi
	addwrite "${EBZR_STORE_DIR}"

	if [[ ! -d ${branch_dir}/.bzr ]]; then
		if [[ ${repo_dir} != "${branch_dir}" && ! -d ${repo_dir}/.bzr ]]; then
			einfo "creating shared bzr repository: ${repo_dir}"
			${EBZR_INIT_REPO_CMD} "${repo_dir}" \
				|| die "${EBZR}: can't create shared repository"
		fi

		if [[ -z ${EBZR_INITIAL_URI} ]]; then
			bzr_initial_fetch "${EBZR_REPO_URI}" "${branch_dir}"
		else
			# Workaround for faster initial download. This clones the
			# branch from a fast server (which may be out of date), and
			# subsequently pulls from the slow original repository.
			bzr_initial_fetch "${EBZR_INITIAL_URI}" "${branch_dir}"
			if [[ ${EBZR_REPO_URI} != "${EBZR_INITIAL_URI}" ]]; then
				EBZR_UPDATE_CMD="${EBZR_UPDATE_CMD} --remember --overwrite" \
					EBZR_OFFLINE="" \
					bzr_update "${EBZR_REPO_URI}" "${branch_dir}"
			fi
		fi
	else
		bzr_update "${EBZR_REPO_URI}" "${branch_dir}"
	fi

	# Restore sandbox environment and umask
	SANDBOX_WRITE=${save_sandbox_write}
	if [[ -n ${save_umask} ]]; then
		umask "${save_umask}" || die
	fi

	cd "${branch_dir}" || die "${EBZR}: can't chdir to ${branch_dir}"

	# Save revision number in environment. #311101
	export EBZR_REVNO=$(${EBZR_REVNO_CMD})

	if [[ -n ${EBZR_WORKDIR_CHECKOUT} ]]; then
		einfo "checking out ..."
		${EBZR_CHECKOUT_CMD} ${EBZR_REVISION:+-r ${EBZR_REVISION}} \
			. "${EBZR_UNPACK_DIR}" || die "${EBZR}: checkout failed"
	else
		einfo "exporting ..."
		${EBZR_EXPORT_CMD} ${EBZR_REVISION:+-r ${EBZR_REVISION}} \
			"${EBZR_UNPACK_DIR}" . || die "${EBZR}: export failed"
	fi
	einfo \
		"revision ${EBZR_REVISION:-${EBZR_REVNO}} is now in ${EBZR_UNPACK_DIR}"

	popd > /dev/null || die "${EBZR}: popd failed"
}

# @FUNCTION: bzr_src_unpack
# @DESCRIPTION:
# Default src_unpack(), calls bzr_fetch.
bzr_src_unpack() {
	bzr_fetch
}
