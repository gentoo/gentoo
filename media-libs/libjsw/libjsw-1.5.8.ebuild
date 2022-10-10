# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="provide a uniform API and user configuration for joysticks and game controllers"
HOMEPAGE="http://freshmeat.net/projects/libjsw/"
SRC_URI="http://wolfsinger.com/~wolfpack/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~riscv x86"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch # 724664
	"${FILESDIR}"/${P}-musl.patch # 713792
)

src_prepare() {
	default

	cp include/jsw.h libjsw/ || die
	bunzip2 libjsw/man/* || die
}

src_configure() {
	tc-export CC CXX
}

src_compile() {
	emake -C libjsw
}

src_install() {
	doheader include/jsw.h

	dodoc README
	dodoc -r jswdemos
	docompress -x /usr/share/doc/${PF}/jswdemos

	cd libjsw || die
	dolib.so libjsw.so.${PV}
	dosym libjsw.so.${PV} /usr/$(get_libdir)/libjsw.so
	dosym libjsw.so.${PV} /usr/$(get_libdir)/libjsw.so.1

	doman man/*
}
