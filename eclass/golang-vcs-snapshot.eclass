# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: golang-vcs-snapshot.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @PROVIDES: golang-base
# @BLURB: eclass to unpack VCS snapshot tarballs for Go software
# @DEPRECATED: go-module.eclass
# @DESCRIPTION:
# This eclass provides a convenience ``src_unpack() ``which unpacks the
# first tarball mentioned in ``SRC_URI`` to its appropriate location in
# ``${WORKDIR}/${P}``, treating ``${WORKDIR}/${P}`` as a go workspace.
# Also, it provides a downstream method of vendoring packages.
#
# The location where the tarball is extracted is defined as
# ``${WORKDIR}/${P}/src/${EGO_PN}``. The location of vendored packages is
# defined as ``${WORKDIR}/${P}/src/${EGO_PN%/*}/vendor`` to match Go's
# vendoring setup.
#
# The typical use case is VCS snapshots coming from github, bitbucket
# and similar services.
#
# Please note that this eclass currently handles only tarballs
# (``.tar.gz``), but support for more formats may be added in the future.
#
# @EXAMPLE:
#
# @CODE
# EGO_PN=github.com/user/package
# EGO_VENDOR=(
#    "github.com/xenolf/lego 6cac0ea7d8b28c889f709ec7fa92e92b82f490dd"
#    "golang.org/x/crypto 453249f01cfeb54c3d549ddb75ff152ca243f9d8 github.com/golang/crypto"
# )
#
# inherit golang-vcs-snapshot
#
# SRC_URI="https://github.com/example/${PN}/tarball/v${PV} -> ${P}.tar.gz
#     ${EGO_VENDOR_URI}"
# @CODE
#
# The above example will extract the tarball to
# ``${WORKDIR}/${P}/src/github.com/user/package``
# and add the vendored tarballs to ``${WORKDIR}/src/${EGO_PN}/vendor``

inherit golang-base

case ${EAPI:-0} in
	5|6|7) ;;
	*) die "${ECLASS} API in EAPI ${EAPI} not yet established."
esac

EXPORT_FUNCTIONS src_unpack

# @ECLASS_VARIABLE: EGO_VENDOR
# @DESCRIPTION:
# This variable contains a list of vendored packages.
# The items of this array are strings that contain the
# import path and the git commit hash for a vendored package.
# If the import path does not start with github.com, the third argument
# can be used to point to a github repository.

declare -arg EGO_VENDOR

_golang-vcs-snapshot_set_vendor_uri() {
	EGO_VENDOR_URI=
	local lib
	for lib in "${EGO_VENDOR[@]}"; do
		lib=(${lib})
		if [[ -n ${lib[2]} ]]; then
			EGO_VENDOR_URI+=" https://${lib[2]}/archive/${lib[1]}.tar.gz -> ${lib[2]//\//-}-${lib[1]}.tar.gz"
		else
			EGO_VENDOR_URI+=" https://${lib[0]}/archive/${lib[1]}.tar.gz -> ${lib[0]//\//-}-${lib[1]}.tar.gz"
		fi
	done
	readonly EGO_VENDOR_URI
}

_golang-vcs-snapshot_set_vendor_uri
unset -f _golang-vcs-snapshot_set_vendor_uri

_golang-vcs-snapshot_dovendor() {
	local VENDOR_PATH=$1 VENDORPN=$2 TARBALL=$3
	rm -fr "${VENDOR_PATH}/${VENDORPN}" || die
	mkdir -p "${VENDOR_PATH}/${VENDORPN}" || die
	tar -C "${VENDOR_PATH}/${VENDORPN}" -x --strip-components 1\
		-f "${DISTDIR}"/${TARBALL} || die
}

# @FUNCTION: golang-vcs-snapshot_src_unpack
# @DESCRIPTION:
# Extract the first archive from ``${A}`` to the appropriate location for
# ``GOPATH``.
golang-vcs-snapshot_src_unpack() {
	local lib vendor_path x
	ego_pn_check
	set -- ${A}
	x="$1"
	mkdir -p "${WORKDIR}/${P}/src/${EGO_PN%/...}" || die
	tar -C "${WORKDIR}/${P}/src/${EGO_PN%/...}" -x --strip-components 1 \
		-f "${DISTDIR}/${x}" || die

	if [[ -n "${EGO_VENDOR}" ]]; then
		vendor_path="${WORKDIR}/${P}/src/${EGO_PN%/...}/vendor"
		mkdir -p "${vendor_path}" || die
		for lib in "${EGO_VENDOR[@]}"; do
			lib=(${lib})
			if [[ -n ${lib[2]} ]]; then
				einfo "Vendoring ${lib[0]} ${lib[2]//\//-}-${lib[1]}.tar.gz"
				_golang-vcs-snapshot_dovendor "${vendor_path}" ${lib[0]} \
					${lib[2]//\//-}-${lib[1]}.tar.gz
			else
				einfo "Vendoring ${lib[0]} ${lib[0]//\//-}-${lib[1]}.tar.gz"
				_golang-vcs-snapshot_dovendor "${vendor_path}" ${lib[0]} \
				${lib[0]//\//-}-${lib[1]}.tar.gz
			fi
		done
	fi
}
