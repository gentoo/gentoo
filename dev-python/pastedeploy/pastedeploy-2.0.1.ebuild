# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="https://pypi.org/project/PasteDeploy/"
# pypi tarball does not include tests
SRC_URI="https://github.com/Pylons/${PN}/archive/${PV}.tar.gz ->  ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/namespace-paste[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	use doc && dodoc docs/*.txt
	find "${D}" -name '*.pth' -delete || die
}
