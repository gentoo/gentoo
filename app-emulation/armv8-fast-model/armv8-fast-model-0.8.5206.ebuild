# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib

MY_P="FM000-KT-00035-r${PV:0:1}p${PV:2:1}-${PV:0-4:2}rel${PV:0-2}"
DESCRIPTION="emulator for a basic ARMv8 platform environment (for running bare metal & Linux)"
HOMEPAGE="https://silver.arm.com/browse/FM00A"
SRC_URI="https://silver.arm.com/download/Development_Tools/ESL:_Fast_Models/Fast_Models/${MY_P}/${MY_P}.tgz"

LICENSE="ARM-FAST-MODEL"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="examples"
RESTRICT="fetch strip"

RDEPEND="sys-libs/glibc
	sys-devel/gcc"

S="${WORKDIR}/Foundation_v8pkg"

QA_PREBUILT="
	opt/${PN}/bin/Foundation_v8
	opt/${PN}/*/lib*.so*
"

pkg_nofetch() {
	einfo "Please visit this URL to download the package:"
	einfo " ${SRC_URI}"
	einfo "Then stick it into ${DISTDIR}"
}

src_install() {
	into /opt/${PN}
	pushd models/Linux64_GCC-4.1 >/dev/null
	dobin Foundation_v8
	dolib.so lib*.so*
	popd >/dev/null

	dodir /opt/bin
	make_wrapper Foundation_v8 /opt/${PN}/bin/Foundation_v8 '' /opt/${PN}/$(get_libdir) /opt/bin

	dodoc doc/*.{pdf,txt}
	use examples && dodoc -r examples
}
