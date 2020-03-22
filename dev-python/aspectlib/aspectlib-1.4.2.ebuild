# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="An aspect-oriented programming, monkey-patch and decorators library"
HOMEPAGE="
	https://github.com/ionelmc/python-aspectlib
	https://pypi.org/project/python-aspectlib
"
SRC_URI="https://github.com/ionelmc/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/fields[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/process-test[${PYTHON_USEDEP}]
		dev-python/profilestats[${PYTHON_USEDEP}]
		dev-python/pytest-travis-fold[${PYTHON_USEDEP}]
		dev-python/pytest-catchlog[${PYTHON_USEDEP}]
		www-servers/tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-py3doc-enhanced-theme
