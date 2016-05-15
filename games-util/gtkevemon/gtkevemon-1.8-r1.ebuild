# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic

IUSE=""
if [[ ${PV} == *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="svn://svn.battleclinic.com/GTKEVEMon/trunk/${PN}"
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://gtkevemon.battleclinic.com/releases/${P}-source.tar.gz
		https://dev.gentoo.org/~wired/distfiles/${P}-learning.patch.gz"
fi

DESCRIPTION="A standalone skill monitoring application for EVE Online"
HOMEPAGE="http://gtkevemon.battleclinic.com"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-libs/libxml2
"
DEPEND="${DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -e 's:Categories=Game;$:Categories=Game;RolePlaying;GTK;:' \
		-i icon/${PN}.desktop || die "sed failed"

	# upstream fix for new character portrait URL
	epatch "${FILESDIR}/${P}-portrait.patch"
	# upstream fix for remap calculation after learning skills removal
	epatch "${DISTDIR}/${P}-learning.patch.gz"
	# pthreads build fix, bug #423305
	epatch "${FILESDIR}/${P}-pthreads-build-fix.patch"

	append-cxxflags -std=c++11
}

src_install() {
	dobin src/${PN}
	doicon icon/${PN}.xpm
	domenu icon/${PN}.desktop
	dodoc CHANGES README TODO
}
