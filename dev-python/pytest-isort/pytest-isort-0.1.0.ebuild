# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="py.test plugin for isort"
HOMEPAGE="https://github.com/moccu/pytest-isort https://pypi.org/project/pytest-isort"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-python/isort-3.9.6[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
	>=dev-python/pytest-cache-1.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
