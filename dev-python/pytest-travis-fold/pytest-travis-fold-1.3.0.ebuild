# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Pytest plugin that folds captured output sections in Travis CI build log"
HOMEPAGE="
	https://github.com/abusalimov/pytest-travis-fold
	https://pypi.org/project/pytest-travis-fold
"
SRC_URI="https://github.com/abusalimov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/pytest-2.6.0[${PYTHON_USEDEP}]
	<dev-python/pytest-4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
