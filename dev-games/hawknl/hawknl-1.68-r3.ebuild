# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A cross-platform network library designed for games"
HOMEPAGE="http://www.hawksoft.com/hawknl/"
SRC_URI="http://www.sonic.net/~philf/download/HawkNL${PV/./}src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="examples"

S="${WORKDIR}/${PN}${PV}"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_configure() {
	tc-export CC

	# bug #855311
	append-flags -fno-strict-aliasing
	filter-lto
}

src_compile() {
	emake -C src -f makefile.linux
}

src_install() {
	emake -j1 -C src -f makefile.linux \
		LIBDIR="${ED}"/usr/$(get_libdir) \
		INCDIR="${ED}"/usr/include install

	dodoc src/{nlchanges.txt,readme.txt}
	if use examples; then
		docinto examples
		dodoc -r samples/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
