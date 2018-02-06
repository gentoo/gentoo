# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# @ECLASS: bzr.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
# Mark Lee <bzr-gentoo-overlay@lazymalevolence.com>
# Ulrich Müller <ulm@gentoo.org>
# Christian Faulhammer <fauli@gentoo.org>
# @BLURB: generic fetching functions for the Bazaar VCS
# @DESCRIPTION:
# The bzr.eclass provides functions to fetch, unpack, patch, and
# bootstrap sources from repositories of the Bazaar distributed version
# control system.  The eclass was originally derived from git.eclass.
#
# Note: Just set EBZR_REPO_URI to the URI of the branch and src_unpack()
# of this eclass will export the branch to ${WORKDIR}/${P}.

inherit eutils

EBZR="bzr.eclass"

case "${EAPI:-0}" in
	0|1) EXPORT_FUNCTIONS src_unpack ;;
	*)   EXPORT_FUNCTIONS src_unpack src_prepare ;;
esac

DEPEND=">=dev-vcs/bzr-2.0.1"
case "${EAPI:-0}" in
	0|1) ;;
	*) [[ ${EBZR_REPO_URI%%:*} = sftp ]] \
		&& DEPEND=">=dev-vcs/bzr-2.0.1[sftp]" ;;
esac

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
: ${EBZR_UPDATE_CMD:="bzr pull"}

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
# Note: If the ebuild uses an sftp:// URI, then in EAPI 0 or 1 it must
# make sure that dev-vcs/bzr was built with USE="sftp".  In EAPI 2 or
# later, the eclass will depend on dev-vcs/bzr[sftp].

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

# @ECLASS-VARIABLE: EBZR_BOOTSTRAP
# @DEFAULT_UNSET
# @DESCRIPTION:
# Bootstrap script or command like autogen.sh or etc.

# @ECLASS-VARIABLE: EBZR_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# bzr.eclass can apply patches in bzr_bootstrap().  You can use regular
# expressions in this variable like *.diff or *.patch and the like.
# Note: These patches will be applied before EBZR_BOOTSTRAP is processed.
#
# Patches are searched both in ${PWD} and ${FILESDIR}.  If not found in
# either location, the installation dies.

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
		popd > /dev/null
	fi
}

# @FUNCTION: bzr_fetch
# @DESCRIPTION:
# Wrapper function to fetch sources from a Bazaar repository with
# bzr branch or bzr pull, depending on whether there is an existing
# working copy.
bzr_fetch() {
	local repo_dir branch_dir
	local save_sandbox_write=${SANDBOX_WRITE}

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

	# Restore sandbox environment
	SANDBOX_WRITE=${save_sandbox_write}

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

	popd > /dev/null
}

# @FUNCTION: bzr_bootstrap
# @DESCRIPTION:
# Apply patches in ${EBZR_PATCHES} and run ${EBZR_BOOTSTRAP} if specified.
bzr_bootstrap() {
	local patch lpatch

	pushd "${S}" > /dev/null || die "${EBZR}: can't chdir to ${S}"

	if [[ -n ${EBZR_PATCHES} ]] ; then
		einfo "apply patches -->"

		for patch in ${EBZR_PATCHES} ; do
			if [[ -f ${patch} ]] ; then
				epatch "${patch}"
			else
				# This loop takes care of wildcarded patches given via
				# EBZR_PATCHES in an ebuild
				for lpatch in "${FILESDIR}"/${patch} ; do
					if [[ -f ${lpatch} ]] ; then
						epatch "${lpatch}"
					else
						die "${EBZR}: ${patch} is not found"
					fi
				done
			fi
		done
	fi

	if [[ -n ${EBZR_BOOTSTRAP} ]] ; then
		einfo "begin bootstrap -->"

		if [[ -f ${EBZR_BOOTSTRAP} ]] && [[ -x ${EBZR_BOOTSTRAP} ]] ; then
			einfo "   bootstrap with a file: ${EBZR_BOOTSTRAP}"
			"./${EBZR_BOOTSTRAP}" \
				|| die "${EBZR}: can't execute EBZR_BOOTSTRAP"
		else
			einfo "   bootstrap with commands: ${EBZR_BOOTSTRAP}"
			"${EBZR_BOOTSTRAP}" \
				|| die "${EBZR}: can't eval EBZR_BOOTSTRAP"
		fi
	fi

	popd > /dev/null
}

# @FUNCTION: bzr_src_unpack
# @DESCRIPTION:
# Default src_unpack(), calls bzr_fetch.  For EAPIs 0 and 1, also calls
# bzr_src_prepare.
bzr_src_unpack() {
	bzr_fetch
	case "${EAPI:-0}" in
		0|1) bzr_src_prepare ;;
	esac
}

# @FUNCTION: bzr_src_prepare
# @DESCRIPTION:
# Default src_prepare(), calls bzr_bootstrap.
bzr_src_prepare() {
	bzr_bootstrap
}
