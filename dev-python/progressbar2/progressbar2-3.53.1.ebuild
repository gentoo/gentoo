# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} pypy3)

inherit distutils-r1

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="https://pypi.org/project/progressbar2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

CDEPEND="!dev-python/progressbar[${PYTHON_USEDEP}]
	dev-python/python-utils[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}"
BDEPEND="${CDEPEND}
	test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/cov/d' pytest.ini || die
	default
}

python_test() {
	cd tests || die
	PYTHONDONTWRITEBYTECODE=1 pytest -vv || die "Tests failed with ${EPYTHON}"
}
