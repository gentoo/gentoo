# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An HP-42S Calculator Simulator"
HOMEPAGE="http://thomasokken.com/free42/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

DEPEND="dev-libs/atk
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/pango
	alsa? ( media-libs/alsa-lib )"

RDEPEND="${DEPEND}
	x11-libs/libX11
	x11-libs/libXmu"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i -e 's/print_gif_name\[FILENAMELEN\]/print_gif_name\[1000\]/' \
		"${S}/gtk/shell_main.cc" || die
	epatch "${FILESDIR}"/${P}-fix-makefile.patch
}

src_compile() {
	local myconf
	use alsa && myconf="AUDIO_ALSA=yes"
	emake CXX="$(tc-getCXX)" BCD_MATH=1 ${myconf} -C "${S}/gtk"
}

src_install() {
	dodoc CREDITS HISTORY README TODO
	dobin gtk/free42dec
}
