# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: golang-vcs.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @PROVIDES: golang-base
# @BLURB: Eclass for fetching and unpacking go repositories.
# @DEPRECATED: go-module.eclass
# @DESCRIPTION:
# This eclass is written to ease the maintenance of live ebuilds
# of software written in the Go programming language.

case ${EAPI} in
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GOLANG_VCS_ECLASS} ]]; then
_GOLANG_VCS_ECLASS=1

inherit estack golang-base go-env

PROPERTIES+=" live"

# @ECLASS_VARIABLE: EGO_PN
# @REQUIRED
# @DESCRIPTION:
# This is the import path for the go package(s). Please emerge dev-lang/go
# and read "go help importpath" for syntax.
#
# Example:
# @CODE
# EGO_PN="github.com/user/package"
# EGO_PN="github.com/user1/package1 github.com/user2/package2"
# @CODE

# @ECLASS_VARIABLE: EGO_STORE_DIR
# @USER_VARIABLE
# @DESCRIPTION:
# Storage directory for Go sources.
#
# This is intended to be set by the user in make.conf. Ebuilds must not set
# it.
#
# EGO_STORE_DIR=${DISTDIR}/go-src

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
# group) and use FEATURES=userpriv.

# @FUNCTION: _golang-vcs_env_setup
# @INTERNAL
# @DESCRIPTION:
# Create EGO_STORE_DIR if necessary.
# Set compile env via go-env.
_golang-vcs_env_setup() {
	debug-print-function ${FUNCNAME} "$@"

	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	: "${EGO_STORE_DIR:=${distdir}/go-src}"

	[[ -n ${EVCS_UMASK} ]] && eumask_push $EVCS_UMASK

	if [[ ! -d ${EGO_STORE_DIR} ]]; then
		(
			addwrite /
			mkdir -p "${EGO_STORE_DIR}"
		) || die "${ECLASS}: unable to create ${EGO_STORE_DIR}"
	fi

	addwrite "${EGO_STORE_DIR}"

	[[ -n ${EVCS_UMASK} ]] && eumask_pop
	mkdir -p "${WORKDIR}/${P}/src" ||
		die "${ECLASS}: unable to create ${WORKDIR}/${P}"
	return 0

	go-env_set_compile_environment
}

# @FUNCTION: _golang-vcs_fetch
# @INTERNAL
# @DESCRIPTION:
# Retrieve the EGO_PN go package along with its dependencies.
_golang-vcs_fetch() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check

	if [[ -z ${EVCS_OFFLINE} ]]; then
		[[ -n ${EVCS_UMASK} ]] && eumask_push ${EVCS_UMASK}

		set -- env GOPATH="${EGO_STORE_DIR}" go get -d -t -u -v -x "${EGO_PN}"
		echo "$@"
		"$@" || die
		# The above dies if you pass repositories in EGO_PN instead of
		# packages, e.g. golang.org/x/tools instead of golang.org/x/tools/cmd/vet.
		# This is being discussed in the following upstream issue:
		# https://github.com/golang/go/issues/11090

		[[ -n ${EVCS_UMASK} ]] && eumask_pop
	fi
	local go_srcpath="${WORKDIR}/${P}/src/${EGO_PN%/...}"
	set -- mkdir -p "${go_srcpath}"
	echo "$@"
	"$@" || die "Unable to create ${go_srcpath}"
	set -- cp -r	"${EGO_STORE_DIR}/src/${EGO_PN%/...}" \
		"${go_srcpath}/.."
	echo "$@"
	"$@" || die "Unable to copy sources to ${go_srcpath}"
	return 0
}

golang-vcs_src_fetch() {
	debug-print-function ${FUNCNAME} "$@"

	_golang-vcs_env_setup
	_golang-vcs_fetch
}

golang-vcs_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	golang-vcs_src_fetch
}

fi

EXPORT_FUNCTIONS src_unpack
