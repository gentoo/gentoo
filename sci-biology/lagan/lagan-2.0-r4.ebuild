# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="lagan20"

DESCRIPTION="The LAGAN suite of tools for whole-genome multiple alignment of genomic DNA"
HOMEPAGE="http://lagan.stanford.edu/lagan_web/index.shtml"
SRC_URI="http://lagan.stanford.edu/lagan_web/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-conflicting-getline.patch
	"${FILESDIR}"/${P}-gcc-4.8.patch
	"${FILESDIR}"/${P}-ambiguous-end.patch
	"${FILESDIR}"/${P}-gcc-9.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-C99-static-inline.patch
	"${FILESDIR}"/${P}-qa-implicit-declarations.patch
)

src_prepare() {
	default
	sed -i "/use Getopt::Long;/ i use lib \"/usr/$(get_libdir)/lagan/lib\";" \
		supermap.pl || die
}

src_configure() {
	tc-export CC CXX
}

src_install() {
	newbin lagan.pl lagan
	newbin slagan.pl slagan
	dobin mlagan
	rm lagan.pl slagan.pl utils/Utils.pm || die

	insinto /usr/$(get_libdir)/lagan/lib
	doins Utils.pm

	exeinto /usr/$(get_libdir)/lagan/utils
	doexe utils/*

	exeinto /usr/$(get_libdir)/lagan
	doexe *.pl anchors chaos glocal order prolagan

	insinto /usr/$(get_libdir)/lagan
	doins *.txt

	dosym ../$(get_libdir)/lagan/supermap.pl /usr/bin/supermap

	newenvd - 99lagan <<- _EOF_
		LAGAN_DIR="${EPREFIX}/usr/$(get_libdir)/lagan"
	_EOF_

	dodoc Readmes/README.*
}
