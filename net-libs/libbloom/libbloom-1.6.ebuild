# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple and small bloom filter implementation in plain C"
HOMEPAGE="https://github.com/jvirkki/libbloom"
SRC_URI="https://github.com/jvirkki/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

PATCHES=("${FILESDIR}"/${PN}-1.5-AR.patch)

src_compile() {
	tc-export AR CC
	emake BITS=default OPT=
}

src_install() {
	doheader bloom.h
	dolib.so build/${PN}.so*
}
