# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P=${P/_p/-}
DESCRIPTION="an (often faster than gawk) awk-interpreter"
HOMEPAGE="https://invisible-island.net/mawk/mawk.html"
SRC_URI="ftp://invisible-island.net/mawk/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="app-eselect/eselect-awk"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

DOCS=( ACKNOWLEDGMENT CHANGES README )

src_prepare() {
	default
	tc-export BUILD_CC
}

src_install() {
	default

	exeinto /usr/share/doc/${PF}/examples
	doexe examples/*
	docompress -x /usr/share/doc/${PF}/examples
}

pkg_postinst() {
	eselect awk update ifunset
}

pkg_postrm() {
	eselect awk update ifunset
}
