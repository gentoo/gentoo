# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: openib.eclass
# @SUPPORTED_EAPIS: 0 1 2 3 4 5 6 7
# @AUTHOR:
# Original Author: Alexey Shvetsov <alexxy@gentoo.org>
# @BLURB: Simplify working with OFED packages

case ${EAPI:-0} in
	[0123456]) inherit eapi7-ver ;;
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI} not supported" ;;
esac

inherit rpm

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="https://www.openfabrics.org/"
LICENSE="|| ( GPL-2 BSD-2 )"

# @ECLASS-VARIABLE: OFED_VER
# @DESCRIPTION:
# Defines OFED version eg 1.4 or 1.4.0.1

# @ECLASS-VARIABLE: OFED_RC
# @DESCRIPTION:
# Sets if this version is RC

# @ECLASS-VARIABLE: OFED_RC_VER
# @DESCRIPTION:
# Sets RC version

# @ECLASS-VARIABLE: OFED_SUFFIX
# @DESCRIPTION:
# Defines OFED package suffix eg -1.ofed1.4

# @ECLASS-VARIABLE: OFED_SRC_SNAPSHOT
# @DESCRIPTION:
# Defines if srcrpm is a snapshot

SLOT="$(ver_cut 1-2 ${OFED_VER})"

# @ECLASS-VARIABLE: OFED_VERSIONS
# @DESCRIPTION:
# Defines array of ofed version supported by eclass

OFED_VERSIONS=(
	"3.12"
	"4.17"
)

# @FUNCTION: block_other_ofed_versions
# @DESCRIPTION:
# function that creates blockers list for ofed
block_other_ofed_versions() {
	local slot
	RDEPEND="${RDEPEND} !sys-fabric/${PN}:0"
	for slot in ${OFED_VERSIONS[@]}; do
		if [[ ${slot} != ${SLOT} ]]; then
			RDEPEND+=" !sys-fabric/${PN}:${slot}"
		fi
	done
}

OFED_BASE_PKGNAME="OFED-${OFED_VER}"
[[ -n $OFED_RC ]] && OFED_BASE_PKGNAME+="-rc${OFED_RC_VER}"

SRC_URI="https://www.openfabrics.org/downloads/OFED/ofed-$(ver_cut 1-3 ${OFED_VER})/${OFED_BASE_PKGNAME}.tgz"

case ${PN} in
	ofed)
		MY_PN="compat-rdma"
		MY_PV="$(ver_cut 1-2 ${OFED_VER})"
		;;
	*)
		MY_PN="${PN}"
		;;
esac

case ${PV} in
	*p*)
		: ${MY_PV:=${PV/p/}}
		;;
	*)
		: ${MY_PV:=${PV}}
		;;
esac

if [[ -z ${OFED_SRC_SNAPSHOT} ]]; then
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
else
	S="${WORKDIR}/${MY_PN}-${MY_PV}-${OFED_SUFFIX}"
fi

# @FUNCTION: openib_src_unpack
# @DESCRIPTION:
# This function will unpack OFED packages
openib_src_unpack() {
	unpack "${A}"
	srcrpm_unpack "./${OFED_BASE_PKGNAME}/SRPMS/${MY_PN}-${MY_PV}-${OFED_SUFFIX}.src.rpm"
}
