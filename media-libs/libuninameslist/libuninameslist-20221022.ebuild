# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library of unicode annotation data"
HOMEPAGE="https://github.com/fontforge/libuninameslist"
SRC_URI="https://github.com/fontforge/libuninameslist/releases/download/${PV}/${PN}-dist-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_configure() {
	econf --enable-frenchlib
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
