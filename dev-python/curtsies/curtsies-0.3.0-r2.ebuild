# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Curses-like terminal wrapper, with colored strings"
HOMEPAGE="https://github.com/thomasballinger/curtsies"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/blessings-1.5[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.1.4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyte[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}"/${PN}-typing.patch )

python_test() {
	nosetests --verbose tests || die
}
