# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A tool to list content of virtual tables in a shared library"
HOMEPAGE="https://github.com/lvc/vtable-dumper"
SRC_URI="https://github.com/lvc/vtable-dumper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

DEPEND="dev-libs/elfutils:0="
RDEPEND="${DEPEND}"

src_configure() {
	tc-export CC
}

src_install() {
	emake prefix="${ED%/}/usr" install
	einstalldocs
}
