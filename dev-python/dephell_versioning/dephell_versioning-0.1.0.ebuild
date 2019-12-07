# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} pypy3 )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="Bump project version like a pro "
HOMEPAGE="https://github.com/dephell/dephell_versioning"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	sys-apps/findutils
	dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='${PN}',version='${PV}',%s)" \
		"packages=find_packages(exclude=['tests'])" \
		> setup.py

	# upstream committed __pycache__ dirs which breaks tests
	find -name '__pycache__' -print0 | xargs -0 rm -r || die

	distutils-r1_python_prepare_all
}
