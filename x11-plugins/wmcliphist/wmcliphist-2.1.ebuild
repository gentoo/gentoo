# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcliphist/wmcliphist-2.1.ebuild,v 1.6 2015/08/06 07:16:40 ago Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Dockable clipboard history application for Window Maker"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmcliphist"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/dockapps

src_compile() {
	tc-export CC
	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	dodoc ChangeLog README
	newdoc ${PN}rc ${PN}rc.sample
}
