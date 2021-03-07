# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="MPD (music player daemon) plugin to G15daemon"
HOMEPAGE="https://sourceforge.net/projects/g15daemon/"
SRC_URI="mirror://sourceforge/g15daemon/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=app-misc/g15daemon-1.9
	dev-libs/libg15
	dev-libs/libg15render
	>=media-libs/libmpd-0.17
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}/${P}-libmpd.patch"
	"${FILESDIR}/${P}-cflags-and-lib-fix.patch"
	"${FILESDIR}/${P}-docdir.patch"
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/${PF}/{COPYING,NEWS} || die
}
