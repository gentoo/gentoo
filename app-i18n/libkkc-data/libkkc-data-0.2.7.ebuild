# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..10} )

inherit python-any-r1

DESCRIPTION="Language model data for libkkc"
HOMEPAGE="https://github.com/ueno/libkkc"
SRC_URI="https://github.com/ueno/${PN%-*}/releases/download/v0.3.5/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
BDEPEND="${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}"/${PN}-python3.patch )
