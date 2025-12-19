# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="https://github.com/bdwgc/libatomic_ops/"
SRC_URI="https://github.com/bdwgc/libatomic_ops/releases/download/v${PV}/${P}.tar.gz"

# See doc/LICENSING.txt
LICENSE="MIT boehm-gc GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_prepare() {
	default
	# ensure LTO patches are applied
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --enable-shared
}

multilib_src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
