# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dump ABI of an ELF object containing DWARF debug info"
HOMEPAGE="https://github.com/lvc/abi-dumper"
SRC_URI="https://github.com/lvc/abi-dumper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-libs/elfutils
	dev-util/vtable-dumper
"
BDEPEND="dev-lang/perl"

src_compile() {
	:
}

src_install() {
	dodir /usr
	perl Makefile.pl -install -prefix "${EPREFIX}/usr" -destdir "${D}" || die
	einstalldocs
}
