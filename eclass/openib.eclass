# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/openib.eclass,v 1.11 2014/04/16 10:09:29 alexxy Exp $

# @ECLASS: openib.eclass
# @AUTHOR:
# Original Author: Alexey Shvetsov <alexxy@gentoo.org>
# @BLURB: Simplify working with OFED packages

inherit eutils rpm versionator

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://www.openfabrics.org/"
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

# @ECLASS-VARIABLE: OFED_SNAPSHOT
# @DESCRIPTION:
# Defines if src tarball is git snapshot

SLOT="${OFED_VER}"

# @ECLASS-VARIABLE: OFED_VERSIONS
# @DESCRIPTION:
# Defines array of ofed version supported by eclass

OFED_VERSIONS=(
	"1.5.4.1"
	"3.5"
	"3.12"
	)

# @FUNCTION: block_other_ofed_versions
# @DESCRIPTION:
# function that creates blockers list for ofed
block_other_ofed_versions() {
	local slot
	RDEPEND="${RDEPEND} !sys-infiniband/${PN}:0"
	for slot in ${OFED_VERSIONS[@]}; do
		if [[ ${slot} != ${SLOT} ]]; then
			RDEPEND+=" !sys-infiniband/${PN}:${slot}"
		fi
	done
}

OFED_BASE_VER=$(get_version_component_range 1-3 ${OFED_VER})

if [ -z $OFED_RC ] ; then
	SRC_URI="https://www.openfabrics.org/downloads/OFED/ofed-${OFED_BASE_VER}/OFED-${OFED_VER}.tgz"
else
	SRC_URI="https://www.openfabrics.org/downloads/OFED/ofed-${OFED_BASE_VER}/OFED-${OFED_VER}-rc${OFED_RC_VER}.tgz"
fi

case ${PN} in
	ofed)
		case ${PV} in
			1.5.*|1.5.*.*)
				MY_PN="ofa_kernel"
				;;
			*)
				MY_PN="compat-rdma"
				;;
		esac
		;;
	*)
		MY_PN="${PN}"
		;;
esac

case ${PV} in
	*p*)
		MY_PV="${PV/p/}"
		;;
	*)
		MY_PV="${PV}"
		;;
esac

case ${MY_PN} in
	ofa_kernel|compat-rdma)
		EXT="tgz"
		;;
	*)
		EXT="tar.gz"
		;;
esac

if [ -z ${OFED_SRC_SNAPSHOT} ]; then
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
else
	S="${WORKDIR}/${MY_PN}-${MY_PV}-${OFED_SUFFIX}"
fi


# @FUNCTION: openib_src_unpack
# @DESCRIPTION:
# This function will unpack OFED packages
openib_src_unpack() {
	unpack ${A}
	if [ -z ${OFED_RC} ]; then
		case ${PN} in
			ofed)
				rpm_unpack "./OFED-${OFED_VER}/SRPMS/${MY_PN}-${OFED_VER}-${OFED_SUFFIX}.src.rpm"
				;;
			*)
				rpm_unpack "./OFED-${OFED_VER}/SRPMS/${MY_PN}-${MY_PV}-${OFED_SUFFIX}.src.rpm"
				;;
		esac
	else
		case ${PN} in
			ofed)
				rpm_unpack "./OFED-${OFED_VER}-rc${OFED_RC_VER}/SRPMS/${MY_PN}-${OFED_VER}-${OFED_SUFFIX}.src.rpm"
				;;
			*)
				rpm_unpack "./OFED-${OFED_VER}-rc${OFED_RC_VER}/SRPMS/${MY_PN}-${MY_PV}-${OFED_SUFFIX}.src.rpm"
				;;
		esac
	fi
	if [ -z ${OFED_SNAPSHOT} ]; then
		case ${PN} in
			ofed)
				unpack ./${MY_PN}-${OFED_VER}.${EXT}
				;;
			*)
				unpack ./${MY_PN}-${MY_PV}.${EXT}
				;;
		esac
	else
		case ${PN} in
			ofed)
				unpack ./${MY_PN}-${OFED_VER}-${OFED_SUFFIX}.${EXT}
				;;
			*)
				unpack ./${MY_PN}-${MY_PV}-${OFED_SUFFIX}.${EXT}
				;;
		esac
	fi
}
