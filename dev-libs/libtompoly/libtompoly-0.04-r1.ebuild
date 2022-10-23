# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="portable ISO C library for polynomial basis arithmetic"
HOMEPAGE="https://www.libtom.net/"
SRC_URI="https://github.com/libtom/libtompoly/releases/download/${PV}/ltp-${PV}.tar.bz2"

LICENSE="|| ( public-domain WTFPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-libs/libtommath"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.04-Fix-Wimplicit-function-declaration.patch
)

src_prepare() {
	default
	sed -i \
		-e 's:\<ar\>:$(AR):' \
		-e "/^LIBPATH/s:/lib:/$(get_libdir):" \
		makefile || die "Fixing makefile failed"
	tc-export AR CC
}

src_install() {
	default
	dodoc changes.txt pb.pdf
	docinto demo
	dodoc demo/demo.c
}
