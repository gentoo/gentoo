# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="very nice backgammon game for X"
HOMEPAGE="http://fawn.unibw-hamburg.de/steuer/xgammon/xgammon.html"
SRC_URI="http://fawn.unibw-hamburg.de/steuer/xgammon/Downloads/${P}a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rman
	x11-misc/imake"

S="${WORKDIR}/${P}a"

PATCHES=(
	"${FILESDIR}"/${P}-broken.patch
	"${FILESDIR}"/${P}-r2-config.patch
	"${FILESDIR}"/${P}-glibc-2.32.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	xmkmf || die
}

src_compile() {
	env PATH=".:${PATH}" emake \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		CDEBUGFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)"
}

pkg_postinst() {
	einfo "xgammon need helvetica fonts"
	einfo "They can be loaded emerging media-fonts/font-adobe-100dpi"
	einfo "or similar. Remember to restart X after loading fonts"
}
