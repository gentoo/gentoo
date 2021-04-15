# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Famous german card game"
HOMEPAGE="http://www.xskat.de/xskat.html"
SRC_URI="http://www.xskat.de/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	media-fonts/font-misc-misc
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="
	x11-base/xorg-proto
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf -a || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		EXTRA_LDOPTIONS="${LDFLAGS}"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	dobin xskat
	newman xskat.man xskat.6
	newicon icon.xbm ${PN}.xbm
	make_desktop_entry ${PN} XSkat /usr/share/pixmaps/${PN}.xbm
	einstalldocs
}
