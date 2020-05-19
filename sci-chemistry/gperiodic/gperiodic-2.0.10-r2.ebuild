# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Periodic table application for Linux"
HOMEPAGE="https://sourceforge.net/projects/gperiodic/"
SRC_URI="http://www.frantz.fi/software/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:0
	x11-libs/gtk+:2
	x11-libs/cairo[X]
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-nls.patch
	sed \
		-e '/Encoding/d' \
		-i ${PN}.desktop || die
}

src_compile() {
	local myopts
	use nls && myopts="enable_nls=1" || myopts="enable_nls=0"
	emake CC=$(tc-getCC) ${myopts}
}

src_install() {
	local myopts
	use nls && myopts="enable_nls=1" || myopts="enable_nls=0"
	emake DESTDIR="${D}" ${myopts} install
	dodoc AUTHORS ChangeLog README NEWS
	newdoc po/README README.translation
}
