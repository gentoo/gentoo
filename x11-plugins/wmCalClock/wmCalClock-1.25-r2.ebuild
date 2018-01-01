# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils multilib toolchain-funcs

DESCRIPTION="WMaker DockApp: A Calendar clock with antialiased text"
HOMEPAGE="http://www.dockapps.net/wmcalclock"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~mips ppc ppc64 sparc x86"
IUSE=""

S="${WORKDIR}/${P}/Src"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc ../{BUGS,CHANGES,HINTS,README,TODO}
}
