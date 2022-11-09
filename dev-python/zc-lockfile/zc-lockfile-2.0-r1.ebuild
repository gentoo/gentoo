# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P=${PN/-/.}-${PV}
DESCRIPTION="Basic inter-process locks"
HOMEPAGE="
	https://github.com/zopefoundation/zc.lockfile/
	https://pypi.org/project/zc.lockfile/
"
SRC_URI="mirror://pypi/${PN::1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"

BDEPEND="
	test? (
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests unittest

python_prepare_all() {
	# rdep is only needed for namespace
	sed -i -e '/install_requires.*setuptools/d' setup.py || die
	# use implicit namespace
	sed -i -e '/namespace_packages/d' setup.py || die
	# do not install README into site-packages
	sed -e '/^    include_package_data/d' -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" -m unittest zc.lockfile.tests -v || die
}
