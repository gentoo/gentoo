# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Monitors inactivity in X and runs the specified program when a timeout occurs"
HOMEPAGE="http://www.freebsdsoftware.org/x11/xidle.html"
SRC_URI="http://distcache.freebsd.org/local-distfiles/novel/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
"
DEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-dead.patch"
)

src_compile() {
	edo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN}{,.c} $($(tc-getPKG_CONFIG) --libs xscrnsaver) $($(tc-getPKG_CONFIG) --libs x11)
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}

pkg_postinst() {
	elog "If you don't specify -program argument for xidle, xlock is ran by default."
	elog "Install x11-misc/xlockmore for xlock if you wish to use default behaviour."
}
