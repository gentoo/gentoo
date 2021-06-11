# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The PHYLogeny Inference Package"
HOMEPAGE="http://evolution.genetics.washington.edu/phylip.html"
SRC_URI="http://evolution.gs.washington.edu/${PN}/download/${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

# 'mix' tool collides with dev-lang/elixir, bug #537514
RDEPEND="
	x11-libs/libXaw
	!dev-lang/elixir"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	mkdir fonts || die
	# clear out old binaries
	rm -r exe || die
}

src_configure() {
	tc-export CC
	append-cflags -Wno-unused-result
}

src_compile() {
	emake -C src -f Makefile.unx all put
}

src_install() {
	mv exe/font* fonts || die "Font move failed"
	mv exe/factor exe/factor-${PN} || die "Renaming factor failed"

	dolib.so exe/*so
	rm exe/*so || die
	dobin exe/*

	dodoc "${FILESDIR}"/README.Gentoo
	docinto html
	dodoc -r phylip.html doc

	insinto /usr/share/phylip
	doins -r fonts
}
