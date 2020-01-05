# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} pypy3 )

inherit distutils-r1

DESCRIPTION="A Django plugin for py.test"
HOMEPAGE="https://pypi.org/project/pytest-django/ https://pytest-django.readthedocs.org https://github.com/pytest-dev/pytest-django"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND="
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/setuptools_scm-1.11.1[${PYTHON_USEDEP}]
"

# not all test dependencies are packaged and this package isn't worth it.
RESTRICT="test"
