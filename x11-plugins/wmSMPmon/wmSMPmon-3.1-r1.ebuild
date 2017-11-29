# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils multilib toolchain-funcs

DESCRIPTION="SMP system monitor dockapp"
HOMEPAGE="http://www.dockapps.net/wmsmpmon"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S="${WORKDIR}/${P}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ../Changelog
}
