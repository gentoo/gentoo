# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="https://pypi.org/project/PasteDeploy/"
# pypi tarball does not include tests
SRC_URI="https://github.com/Pylons/${PN}/archive/${PV}.tar.gz ->  ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc"

RDEPEND="dev-python/namespace-paste[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i 's:"pytest-runner"::' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	use doc && dodoc docs/*.txt
	find "${D}" -name '*.pth' -delete || die
}
