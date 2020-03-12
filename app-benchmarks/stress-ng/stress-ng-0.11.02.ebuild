# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Stress test for a computer system with various selectable ways"
HOMEPAGE="https://kernel.ubuntu.com/~cking/stress-ng/"
SRC_URI="https://kernel.ubuntu.com/~cking/tarballs/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="
	dev-libs/libaio
	dev-libs/libbsd
	dev-libs/libgcrypt:0=
	net-misc/lksctp-tools
	sys-apps/attr
	sys-apps/keyutils:=
	sys-libs/libapparmor
	sys-libs/libcap
	sys-libs/zlib
"

RDEPEND="${DEPEND}"

DOCS=( "README" "README.Android" "TODO" "syscalls.txt" )

PATCHES=( "${FILESDIR}/${PN}-0.11.02-makefile.patch" )

src_compile() {
	tc-export CC

	default
}
