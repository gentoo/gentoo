# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="GUI for XDS that is supposed to help both novice and experienced users"
HOMEPAGE="http://strucbio.biologie.uni-konstanz.de/xdswiki/index.php/XdsGUI"
SRC_URI="
	amd64? ( ftp://turn5.biologie.uni-konstanz.de/pub/xdsGUI.rhel6.64 -> ${P}.64 )
	x86? ( ftp://turn5.biologie.uni-konstanz.de/pub/xdsGUI.rhel6.32 -> ${P}.32 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-util/xxdiff
	sci-chemistry/xds-bin
	sci-chemistry/xdsstat-bin
	sci-visualization/xds-viewer"
DEPEND=""

S="${WORKDIR}"

QA_PREBUILT="opt/bin/*"

src_unpack() {
	if use amd64; then
		cp -rf "${DISTDIR}"/${P}.64 ${PN} || die
	elif use x86; then
		cp -rf "${DISTDIR}"/${P}.32 ${PN} || die
	fi
}

src_install() {
	exeinto /opt/bin
	doexe ${PN}
}
