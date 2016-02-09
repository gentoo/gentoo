# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib

MY_PN="ut_linux_megarc"
MY_PV="${PV//./-}"
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="LSI Logic MegaRAID Text User Interface management tool"
# Previous releases from LSI directly required a click-through EULA; but the
# upstream website no longer requires this consistently: most old files have
# two or more download pages, and while one of the pages has a generic
# click-through download form, the file-specific download page only requires
# click-through on some items. See also sys-block/lsiutil, sys-block/megarc
HOMEPAGE="http://www.avagotech.com/cs/Satellite?q=megacli&pagename=AVG2%2FsearchLayout&locale=avg_en&within=megacli&Search=megarc&srch-radio=new&Submit=Search"
SRC_URI="
	http://www.avagotech.com/docs-and-downloads/legacy-raid-controllers/legacy-raid-controllers-common-files/${MY_P}.zip
	http://www.avagotech.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/README_FOR_${MY_P}-zip.txt"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip
	doc? ( app-text/antiword )"
RDEPEND=""

RESTRICT="mirror bindist"

S="${WORKDIR}"

QA_PREBUILT="/opt/bin/megarc"

pkg_setup() {
	use amd64 && { has_multilib_profile || die "needs multilib profile on amd64"; }
}

src_compile() {
	use doc && antiword ut_linux.doc > ${PN}-manual.txt
}

src_install() {
	use doc && dodoc ${PN}-manual.txt
	newdoc ut_linux_${PN}_${PV}.txt ${PN}-release-${PV}.txt
	newdoc "${DISTDIR}"/README_FOR_${MY_P}-zip.txt README

	exeinto /opt/bin
	newexe megarc.bin megarc || die
}
