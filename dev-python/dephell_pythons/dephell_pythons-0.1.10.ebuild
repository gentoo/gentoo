# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Work with python versions"
HOMEPAGE="https://github.com/dephell/dephell_pythons"
SRC_URI="https://github.com/dephell/${PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v.${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/dephell_specifier[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# tests try to explicitly run python2 from python3
RESTRICT="test"

distutils_enable_tests pytest

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='${PN}',version='${PV}',%s)"\
		"packages=find_packages(exclude=['tests'])" \
		> setup.py

	distutils-r1_python_prepare_all
}
