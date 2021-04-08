# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="On the fly conversion of Python docstrings to markdown"
HOMEPAGE="https://github.com/krassowski/docstring-to-markdown"
# PyPI tarball doesn't include tests
SRC_URI="https://github.com/krassowski/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/pytest-flake8[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove pytest-cov usage
	sed -i -e "/--cov/d" setup.cfg || die
	distutils-r1_python_prepare_all
}
