# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Dice parsing and evaluation library"
HOMEPAGE="https://github.com/borntyping/python-dice"
SRC_URI="https://github.com/borntyping/python-dice/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? (
	dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.1[${PYTHON_USEDEP}]
"

src_prepare() {
	if use test; then
		sed -i -e "s/--cov=dice //g" tox.ini || die "Could not remove pytest-cov usage for tests."
	fi
	default
}

distutils_enable_tests pytest
