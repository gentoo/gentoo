# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit multilib

DESCRIPTION="LSI Logic MegaRAID Text User Interface management tool"
HOMEPAGE="http://www.lsi.com"
SRC_URI="http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/ut_linux_${PN}_${PV}.zip"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip
	doc? ( app-text/antiword )"
RDEPEND=""

RESTRICT="mirror"

S="${WORKDIR}"

QA_PRESTRIPPED="/opt/bin/megarc"

pkg_setup() {
	use amd64 && { has_multilib_profile || die "needs multilib profile on amd64"; }
}

src_compile() {
	use doc && antiword ut_linux.doc > ${PN}-manual.txt
}

src_install() {
	use doc && dodoc ${PN}-manual.txt
	newdoc ut_linux_${PN}_${PV}.txt ${PN}-release-${PV}.txt

	exeinto /opt/bin
	newexe megarc.bin megarc || die
}
