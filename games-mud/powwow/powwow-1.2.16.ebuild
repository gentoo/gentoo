# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="PowWow Console MUD Client"
HOMEPAGE="http://hoopajoo.net/projects/powwow.html"
SRC_URI="http://hoopajoo.net/static/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	# note that that the extra, seemingly-redundant files installed are
	# actually used by in-game help commands
	sed -i \
		-e "s/pkgdata_DATA = powwow.doc/pkgdata_DATA = /" \
		Makefile.am || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	egamesconf --includedir=/usr/include
}

src_install () {
	DOCS="ChangeLog Config.demo Hacking NEWS powwow.doc powwow.help README.* TODO" \
		default
	prepgamesdirs
}
