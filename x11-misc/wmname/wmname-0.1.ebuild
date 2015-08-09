# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils toolchain-funcs

DESCRIPTION="utility to set the name of your window manager"
HOMEPAGE="http://tools.suckless.org/wmname"
SRC_URI="http://dl.suckless.org/tools/wmname-0.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)" || die
}

src_install() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)" \
		PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install || die
	dodoc README || die
}
