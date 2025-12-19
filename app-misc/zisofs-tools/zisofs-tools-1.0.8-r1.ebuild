# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="User utilities for zisofs"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/fs/zisofs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static"

RDEPEND=">=virtual/zlib-1.1.4:="
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Clang 16
	sed -i -e 's:configure.in:configure.ac:' Makefile || die
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	default
}

src_install() {
	emake INSTALLROOT="${D}" install
	einstalldocs
}
