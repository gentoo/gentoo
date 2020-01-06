# Copyright 2019 Gentoo authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-module.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: basic eclass for building software written as go modules
# @DESCRIPTION:
# This eclass provides basic settings and functions
# needed by all software written in the go programming language that uses
# go modules.
#
# You will know the software you are packaging uses modules because
# it will have files named go.sum and go.mod in its top-level source
# directory. If it does not have these files, use the golang-* eclasses.
#
# If it has these files and a directory named vendor in its top-level
# source directory, you only need to inherit the eclass since upstream
# is vendoring the dependencies.
#
# If it does not have a vendor directory, you should use the EGO_VENDOR
# variable and the go-module_vendor_uris function as shown in the
# example below to handle dependencies.
#
# Since Go programs are statically linked, it is important that your ebuild's
# LICENSE= setting includes the licenses of all statically linked
# dependencies. So please make sure it is accurate.
#
# @EXAMPLE:
#
# @CODE
#
# inherit go-module
#
# EGO_VENDOR=(
#	"github.com/xenolf/lego 6cac0ea7d8b28c889f709ec7fa92e92b82f490dd"
# "golang.org/x/crypto 453249f01cfeb54c3d549ddb75ff152ca243f9d8 github.com/golang/crypto"
# )
#
# SRC_URI="https://github.com/example/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
# $(go-module_vendor_uris)"
#
# @CODE

case ${EAPI:-0} in
	7) ;;
	*) die "${ECLASS} API in EAPI ${EAPI} not yet established."
esac

if [[ -z ${_GO_MODULE} ]]; then

_GO_MODULE=1

BDEPEND=">=dev-lang/go-1.12"

# Force go to build in module mode.
# In this mode the GOPATH environment variable is ignored.
# this will become the default in the future.
export GO111MODULE=on

# Set the default for the go build cache
# See "go help environment" for information on this setting
export GOCACHE="${T}/go-build"

# The following go flags should be used for all builds.
# -mod=vendor stopps downloading of dependencies from the internet.
# -v prints the names of packages as they are compiled
# -x prints commands as they are executed
export GOFLAGS="-mod=vendor -v -x"

# Do not complain about CFLAGS etc since go projects do not use them.
QA_FLAGS_IGNORED='.*'

# Go packages should not be stripped with strip(1).
RESTRICT="strip"

EXPORT_FUNCTIONS src_unpack pkg_postinst

# @ECLASS-VARIABLE: EGO_VENDOR
# @DESCRIPTION:
# This variable contains a list of vendored packages.
# The items of this array are strings that contain the
# import path and the git commit hash for a vendored package.
# If the import path does not start with github.com, the third argument
# can be used to point to a github repository.

# @FUNCTION: go-module_vendor_uris
# @DESCRIPTION:
# Convert the information in EGO_VENDOR to a format suitable for
# SRC_URI.
# A call to this function should be added to SRC_URI in your ebuild if
# the upstream package does not include vendored dependencies.
go-module_vendor_uris() {
	local hash import line repo x
	for line in "${EGO_VENDOR[@]}"; do
		read -r import hash repo x <<< "${line}"
		if [[ -n $x ]]; then
			eerror "Trailing information in EGO_VENDOR in ${P}.ebuild"
			eerror "${line}"
			eerror "Trailing information is: \"$x\""
			die "Invalid EGO_VENDOR format"
		fi
		: "${repo:=${import}}"
		echo "https://${repo}/archive/${hash}.tar.gz -> ${repo//\//-}-${hash}.tar.gz"
	done
}

# @FUNCTION: go-module_src_unpack
# @DESCRIPTION:
# Extract all archives in ${a} which are not nentioned in ${EGO_VENDOR}
# to their usual locations then extract all archives mentioned in
# ${EGO_VENDOR} to ${S}/vendor.
go-module_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"
	local f hash import line repo tarball vendor_tarballs x
	vendor_tarballs=()
	for line in "${EGO_VENDOR[@]}"; do
		read -r import hash repo x <<< "${line}"
		if [[ -n $x ]]; then
			eerror "Trailing information in EGO_VENDOR in ${P}.ebuild"
			eerror "${line}"
			die "Invalid EGO_VENDOR format"
		fi
		: "${repo:=${import}}"
		vendor_tarballs+=("${repo//\//-}-${hash}.tar.gz")
	done
	for f in $A; do
		[[ -n ${vendor_tarballs[*]} ]] && has "$f" "${vendor_tarballs[@]}" &&
			continue
		unpack "$f"
	done

	[[ -z ${vendor_tarballs[*]} ]] && return
	for line in "${EGO_VENDOR[@]}"; do
		read -r import hash repo _ <<< "${line}"
		: "${repo:=${import}}"
		tarball=${repo//\//-}-${hash}.tar.gz
		ebegin "Vendoring ${import} ${tarball}"
		rm -fr "${S}/vendor/${import}" || die
		mkdir -p "${S}/vendor/${import}" || die
		tar -C "${S}/vendor/${import}" -x --strip-components 1 \
			-f "${DISTDIR}/${tarball}" || die
		eend
	done
}

# @FUNCTION: go-module_live_vendor
# @DESCRIPTION:
# This function is used in live ebuilds to vendor the dependencies when
# upstream doesn't vendor them.
go-module_live_vendor() {
	debug-print-function ${FUNCNAME} "$@"

	has live ${PROPERTIES} ||
		die "${FUNCNAME} only allowed in live ebuilds"
	[[ "${EBUILD_PHASE}" == unpack ]] ||
		die "${FUNCNAME} only allowed in src_unpack"
	[[ -d "${S}"/vendor ]] ||
		die "${FUNCNAME} only allowed when upstream isn't vendoring"

	pushd "${S}" >& /dev/null || die
	go mod vendor || die
	popd >& /dev/null || die
}

# @FUNCTION: go-module_pkg_postinst
# @DESCRIPTION:
# Display a warning about security updates for Go programs.
go-module_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"
	[[ -n ${REPLACING_VERSIONS} ]] && return 0
	ewarn "${PN} is written in the Go programming language."
	ewarn "Since this language is statically linked, security"
	ewarn "updates will be handled in individual packages and will be"
	ewarn "difficult for us to track as a distribution."
	ewarn "For this reason, please update any go packages asap when new"
	ewarn "versions enter the tree or go stable if you are running the"
	ewarn "stable tree."
}

fi
