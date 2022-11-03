# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit python-any-r1

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
