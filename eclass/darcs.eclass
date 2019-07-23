# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: darcs.eclass
# @MAINTAINER:
# "Gentoo's Haskell Language team" <haskell@gentoo.org>
# Sergei Trofimovich <slyfox@gentoo.org>
# @AUTHOR:
# Original Author: Jeffrey Yasskin <jyasskin@mail.utexas.edu>
#               <rphillips@gentoo.org> (tla eclass author)
# Andres Loeh   <kosmikus@gentoo.org> (darcs.eclass author)
# Alexander Vershilov <alexander.vershilov@gmail.com> (various contributions)
# @BLURB: This eclass provides functions for fetch and unpack darcs repositories
# @DESCRIPTION:
# This eclass provides the generic darcs fetching functions.
#
# Define the EDARCS_REPOSITORY variable at least.
# The ${S} variable is set to ${WORKDIR}/${P}.

# TODO:

# support for tags

# eshopts_{push,pop}
case "${EAPI:-0}" in
	4|5|6) inherit eutils ;;
	7)     inherit estack ;;
	*) ;;
esac

# Don't download anything other than the darcs repository
SRC_URI=""

# You shouldn't change these settings yourself! The ebuild/eclass inheriting
# this eclass will take care of that.

# --- begin ebuild-configurable settings

# darcs command to run
# @ECLASS-VARIABLE: EDARCS_DARCS_CMD
# @DESCRIPTION:
# Path to darcs binary.
: ${EDARCS_DARCS_CMD:=darcs}

# darcs commands with command-specific options

# @ECLASS-VARIABLE: EDARCS_GET_CMD
# @DESCRIPTION:
# First fetch darcs command.
: ${EDARCS_GET_CMD:=get --lazy}

# @ECLASS-VARIABLE: EDARCS_UPDATE_CMD
# @DESCRIPTION:
# Repo update darcs command.
: ${EDARCS_UPDATE_CMD:=pull}

# @ECLASS-VARIABLE: EDARCS_OPTIONS
# @DESCRIPTION:
# Options to pass to both the "get" and "update" commands
: ${EDARCS_OPTIONS:=--set-scripts-executable}

# @ECLASS-VARIABLE: EDARCS_TOP_DIR
# @DESCRIPTION:
# Where the darcs repositories are stored/accessed
: ${EDARCS_TOP_DIR:=${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/darcs-src}

# @ECLASS-VARIABLE: EDARCS_REPOSITORY
# @DESCRIPTION:
# The URI to the repository.
: ${EDARCS_REPOSITORY:=}

# @ECLASS-VARIABLE: EDARCS_OFFLINE
# @DESCRIPTION:
# Set this variable to a non-empty value to disable the automatic updating of
# a darcs repository. This is intended to be set outside the darcs source
# tree by users. Defaults to EVCS_OFFLINE value.
: ${EDARCS_OFFLINE:=${EVCS_OFFLINE}}

# @ECLASS-VARIABLE: EDARCS_CLEAN
# @DESCRIPTION:
# Set this to something to get a clean copy when updating
# (removes the working directory, then uses EDARCS_GET_CMD to
# re-download it.)
: ${EDARCS_CLEAN:=}

# --- end ebuild-configurable settings ---

PROPERTIES+=" live"

case ${EAPI:-0} in
	[0-6]) # no need to care about 5-HDEPEND and similar
		DEPEND="dev-vcs/darcs
			net-misc/rsync"
		;;
	*)
		BDEPEND="dev-vcs/darcs
			net-misc/rsync"
		;;
esac

# @FUNCTION: darcs_patchcount
# @DESCRIPTION:
# Internal function to determine amount of patches in repository.
darcs_patchcount() {
	set -- $(HOME="${EDARCS_TOP_DIR}" ${EDARCS_DARCS_CMD} show repo --repodir="${EDARCS_TOP_DIR}/${EDARCS_LOCALREPO}" | grep "Num Patches")
	# handle string like: "    Num Patches: 3860"
	echo ${3}
}

# @FUNCTION: darcs_fetch
# @DESCRIPTION:
# Internal function is called from darcs_src_unpack
darcs_fetch() {
	# The local directory to store the repository (useful to ensure a
	# unique local name); relative to EDARCS_TOP_DIR
	[[ -z ${EDARCS_LOCALREPO} ]] && [[ -n ${EDARCS_REPOSITORY} ]] \
		&& EDARCS_LOCALREPO=${EDARCS_REPOSITORY%/} \
		&& EDARCS_LOCALREPO=${EDARCS_LOCALREPO##*/}

	debug-print-function ${FUNCNAME} $*

	if [[ -n ${EDARCS_CLEAN} ]]; then
		addwrite "${EDARCS_TOP_DIR}/${EDARCS_LOCALREPO}"
		rm -rf "${EDARCS_TOP_DIR}/${EDARCS_LOCALREPO}"
	fi

	# create the top dir if needed
	if [[ ! -d ${EDARCS_TOP_DIR} ]]; then
		# note that the addwrite statements in this block are only there to allow creating EDARCS_TOP_DIR;
		# we've already allowed writing inside it
		# this is because it's simpler than trying to find out the parent path of the directory, which
		# would need to be the real path and not a symlink for things to work (so we can't just remove
		# the last path element in the string)
		debug-print "${FUNCNAME}: checkout mode. creating darcs directory"
		addwrite /foobar
		addwrite /
		mkdir -p "${EDARCS_TOP_DIR}"
		export SANDBOX_WRITE="${SANDBOX_WRITE//:\/foobar:\/}"
	fi

	# in case EDARCS_DARCS_DIR is a symlink to a dir, get the real
	# dir's path, otherwise addwrite() doesn't work.
	pushd . || die
	cd -P "${EDARCS_TOP_DIR}" > /dev/null
	EDARCS_TOP_DIR="`/bin/pwd`"

	# disable the sandbox for this dir
	addwrite "${EDARCS_TOP_DIR}"

	# determine checkout or update mode and change to the right directory.
	if [[ ! -d "${EDARCS_TOP_DIR}/${EDARCS_LOCALREPO}/_darcs" ]]; then
		mode=get
		cd "${EDARCS_TOP_DIR}"
	else
		mode=update
		cd "${EDARCS_TOP_DIR}/${EDARCS_LOCALREPO}"
	fi

	# commands to run
	local    cmdget="${EDARCS_DARCS_CMD} ${EDARCS_GET_CMD}          ${EDARCS_OPTIONS} --repo-name=${EDARCS_LOCALREPO} ${EDARCS_REPOSITORY}"
	local cmdupdate="${EDARCS_DARCS_CMD} ${EDARCS_UPDATE_CMD} --all ${EDARCS_OPTIONS}                                 ${EDARCS_REPOSITORY}"

	if [[ ${mode} == "get" ]]; then
		einfo "Running ${cmdget}"
		HOME="${EDARCS_TOP_DIR}" ${cmdget} || die "darcs get command failed"
	elif [[ -n ${EDARCS_OFFLINE} ]] ; then
		einfo "Offline update"
	elif [[ ${mode} == "update" ]]; then
		einfo "Running ${cmdupdate}"
		HOME="${EDARCS_TOP_DIR}" ${cmdupdate} || die "darcs update command failed"
	fi

	export EDARCS_PATCHCOUNT=$(darcs_patchcount)
	einfo "    patches in repo: ${EDARCS_PATCHCOUNT}"

	popd || die
}

# @FUNCTION: darcs_src_unpack
# @DESCRIPTION:
# src_upack function
darcs_src_unpack() {
	# The local directory to store the repository (useful to ensure a
	# unique local name); relative to EDARCS_TOP_DIR
	[[ -z ${EDARCS_LOCALREPO} ]] && [[ -n ${EDARCS_REPOSITORY} ]] \
		&& EDARCS_LOCALREPO=${EDARCS_REPOSITORY%/} \
		&& EDARCS_LOCALREPO=${EDARCS_LOCALREPO##*/}

	debug-print-function ${FUNCNAME} $*

	debug-print "${FUNCNAME}: init:
	EDARCS_DARCS_CMD=${EDARCS_DARCS_CMD}
	EDARCS_GET_CMD=${EDARCS_GET_CMD}
	EDARCS_UPDATE_CMD=${EDARCS_UPDATE_CMD}
	EDARCS_OPTIONS=${EDARCS_OPTIONS}
	EDARCS_TOP_DIR=${EDARCS_TOP_DIR}
	EDARCS_REPOSITORY=${EDARCS_REPOSITORY}
	EDARCS_LOCALREPO=${EDARCS_LOCALREPO}
	EDARCS_CLEAN=${EDARCS_CLEAN}"

	einfo "Fetching darcs repository ${EDARCS_REPOSITORY} into ${EDARCS_TOP_DIR}..."
	darcs_fetch

	einfo "Copying ${EDARCS_LOCALREPO} from ${EDARCS_TOP_DIR}..."
	debug-print "Copying ${EDARCS_LOCALREPO} from ${EDARCS_TOP_DIR}..."

	# probably redundant, but best to make sure
	# Use ${WORKDIR}/${P} rather than ${S} so user can point ${S} to something inside.
	mkdir -p "${WORKDIR}/${P}"

	eshopts_push -s dotglob	# get any dotfiles too.
	rsync -rlpgo "${EDARCS_TOP_DIR}/${EDARCS_LOCALREPO}"/* "${WORKDIR}/${P}"
	eshopts_pop

	einfo "Darcs repository contents are now in ${WORKDIR}/${P}"

}

EXPORT_FUNCTIONS src_unpack
