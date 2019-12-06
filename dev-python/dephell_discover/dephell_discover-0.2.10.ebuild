# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Find project modules and data files (packages and package_data for setup.py)"
HOMEPAGE="https://github.com/dephell/dephell_discover"
SRC_URI="https://github.com/dephell/${PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v.${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/attrs[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='${PN}',version='${PV}',%s)"\
		"packages=find_packages(exclude=['tests'])" \
		> setup.py

	distutils-r1_python_prepare_all
}
