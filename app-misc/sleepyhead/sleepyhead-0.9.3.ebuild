# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/sleepyhead/sleepyhead-0.9.3.ebuild,v 1.3 2014/08/10 18:08:51 slyfox Exp $

EAPI=4
inherit eutils qt4-r2
DESCRIPTION="Software used to analyze data from CPAP machines"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/sleepyhead/index.php?title=Main_Page"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="https://github.com/rich0/rich0-sleepyhead/tarball/${PV} -> ${P}.tgz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="virtual/opengl
		x11-libs/libX11
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtwebkit:4
		virtual/glu"
RDEPEND="${DEPEND}"

S="${WORKDIR}/rich0-rich0-sleepyhead-34e0b92"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_prepare() {
#	qt4_src_prepare
	cd "{$S}"
	epatch "${FILESDIR}/common_gui.patch"

#	sed -i '1i#define OF(x) x' quazip/ioapi.h quazip/unzip.c quazip/unzip.h \
#	   quazip/zip.c quazip/zip.h quazip/zlib.h
	eqmake4 SleepyHeadQT.pro
}

src_install() {
	cd "{$S}"
	dobin SleepyHead || die
	dodoc README || die
	dodoc docs/* || die
}
