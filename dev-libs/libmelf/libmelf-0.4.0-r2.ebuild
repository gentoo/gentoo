# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="libmelf is a library interface for manipulating ELF object files"
HOMEPAGE="https://www.hick.org/code/skape/libmelf/"
SRC_URI="https://www.hick.org/code/skape/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

PATCHES=(
	# This patch was gained from the elfsign-0.2.2 release
	"${FILESDIR}"/${PN}-0.4.1-unfinal-release.patch
	# Cleanup stuff
	"${FILESDIR}"/${PN}-0.4.0-r1-gcc-makefile-cleanup.patch
	# Respect LDFLAGS when linking, set SONAME
	"${FILESDIR}"/${PN}-0.4.0-r2-ldflags-soname.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC AR RANLIB
	append-flags -fPIC
	default
}

src_compile() {
	emake OPTFLAGS="${CFLAGS}"
}

src_install() {
	dobin tools/elfres

	dolib.so libmelf.so
	use static-libs && dolib.a libmelf.a

	insinto /usr/include
	doins melf.h stdelf.h

	HTML_DOCS=( docs/html/. )
	einstalldocs
}
