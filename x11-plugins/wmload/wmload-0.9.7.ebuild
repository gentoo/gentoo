# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="yet another dock application showing a system load gauge"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmload"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.6-solaris.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	dodoc README
	domenu "${FILESDIR}"/${PN}.desktop
}
