# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit python-any-r1

DESCRIPTION="Language model data for libkkc"
HOMEPAGE="https://github.com/ueno/libkkc"
SRC_URI="https://github.com/ueno/${PN%-*}/releases/download/v0.3.5/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
BDEPEND="$(python_gen_any_dep 'dev-libs/marisa[python,${PYTHON_USEDEP}]')"

PATCHES=( "${FILESDIR}"/${PN}-python3.patch )

python_check_deps() {
	python_has_version "dev-python/marisa[python,${PYTHON_USEDEP}]"
}
