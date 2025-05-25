# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic python-any-r1

DESCRIPTION="TCP proxy for applications that don't speak IPv6"
HOMEPAGE="https://github.com/wojtekka/6tunnel"
SRC_URI="https://github.com/wojtekka/6tunnel/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv ~s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	# bug #943850
	append-cflags -std=gnu17

	default
}
