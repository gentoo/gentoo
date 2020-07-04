# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="library for floating point number manipulation"
HOMEPAGE="https://www.libtom.net/"
SRC_URI="https://github.com/libtom/libtomfloat/releases/download/${PV}/ltf-${PV}.tar.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-libs/libtommath"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e 's:\<ar\>:$(AR):' \
		-e 's:\<ranlib\>:$(RANLIB):' \
		-e "/^LIBPATH/s:/lib:/$(get_libdir):" \
		makefile || die "Fixing makefile failed"
	tc-export AR CC RANLIB
}

src_install() {
	default
	dodoc changes.txt float.pdf WARNING
	docinto demos
	dodoc demos/ex1.c
}
