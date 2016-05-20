# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Dump ABI of an ELF object containing DWARF debug info"
HOMEPAGE="https://github.com/lvc/abi-dumper"
SRC_URI="https://github.com/lvc/abi-dumper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-libs/elfutils
	dev-util/vtable-dumper"

src_compile() {
	:
}

src_install() {
	dodir /usr
	perl Makefile.pl -install -prefix "${EPREFIX}/usr" -destdir "${D}" || die
	einstalldocs
}
