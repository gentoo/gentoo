# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Dockable clipboard history application for Window Maker"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmcliphist"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3[X]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/dockapps

src_prepare() {
	default

	sed -e '/^PREFIX/s:=.*:=/usr:' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	default

	newdoc ${PN}rc ${PN}rc.sample
}
