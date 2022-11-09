# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="https://progressbar-2.readthedocs.io/ https://pypi.org/project/progressbar2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/python-utils-3.0.0[${PYTHON_USEDEP}]
	!dev-python/progressbar
"
BDEPEND="
	test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/cov/d' pytest.ini || die
	default
}

python_test() {
	PYTHONDONTWRITEBYTECODE=1 epytest tests
}
