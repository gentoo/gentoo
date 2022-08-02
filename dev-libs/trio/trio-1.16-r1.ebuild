# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Portable string functions, focus on the *printf() and *scanf() clones"
HOMEPAGE="https://daniel.haxx.se/projects/trio/"
SRC_URI="mirror://sourceforge/ctrio/${P}.tar.gz"

LICENSE="trio"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-no-inline.patch
	"${FILESDIR}"/${P}-destdir.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
	"${FILESDIR}"/${P}-symlinks.patch
	"${FILESDIR}"/${P}-ldflags.patch
)
HTML_DOCS=( html/. )

src_prepare() {
	default

	# Don't install the static library
	sed -e 's/$(INSTALL_DATA) $(TARGETLIB)/$(INSTALL_DATA)/' \
		-e 's/configure.in/configure.ac/' \
		-i Makefile.in || die

	eautoreconf
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_test() {
	emake regression
	LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH}" ./regression || die
}
