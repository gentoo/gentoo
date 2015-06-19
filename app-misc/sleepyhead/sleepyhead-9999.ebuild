# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/sleepyhead/sleepyhead-9999.ebuild,v 1.4 2014/08/10 18:08:51 slyfox Exp $

EAPI=5
inherit eutils git-2 qt4-r2
DESCRIPTION="Software used to analyze data from CPAP machines"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/sleepyhead/index.php?title=Main_Page"

# Point to any required sources; these will be automatically downloaded by
# Portage.
EGIT_REPO_URI="git://github.com/rich0/rich0-sleepyhead.git"
EGIT_BRANCH="rich-test"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE="debug"

DEPEND="virtual/opengl:=
		x11-libs/libX11:=
		dev-qt/qtcore:4=
		dev-qt/qtgui:4=
		dev-qt/qtopengl:4=
		dev-qt/qtwebkit:4=
		dev-libs/quazip:="
RDEPEND="${DEPEND}"

src_unpack() {
git-2_src_unpack
}

src_prepare() {
#	qt4_src_prepare
	cd "{$S}"
#	sed -i '1i#define OF(x) x' quazip/ioapi.h quazip/unzip.c quazip/unzip.h \
#           quazip/zip.c quazip/zip.h quazip/zlib.h
	eqmake4 SleepyHeadQT.pro
}

src_install() {
	cd "{$S}"
	dobin sleepyhead/SleepyHead || die
	dodoc README || die
	dodoc sleepyhead/docs/* || die
}
