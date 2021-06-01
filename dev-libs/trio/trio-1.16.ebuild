# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Portable string functions, focus on the *printf() and *scanf() clones"
HOMEPAGE="https://daniel.haxx.se/projects/trio/"
SRC_URI="mirror://sourceforge/ctrio/${P}.tar.gz"

LICENSE="trio"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-no-inline.patch
)
HTML_DOCS=( html/. )

src_prepare() {
	default
	sed -i '/$(CC)/s/-o/$(LOCAL_LDFLAGS) -o/' Makefile.in || die
}

src_compile() {
	emake AR="$(tc-getAR)" LOCAL_LDFLAGS="${LDFLAGS}"
	ln -s libtrio.so.2{.0.0,} || die
	ln -s libtrio.so{.2.0.0,} || die
}

src_test() {
	emake LOCAL_LDFLAGS="${LDFLAGS}" regression
	LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH}" ./regression || die
}

src_install() {
	doheader trio*.h
	dolib.so libtrio.so*
	einstalldocs
}
