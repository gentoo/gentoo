# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 vcs-snapshot

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="http://pythonpaste.org/deploy/ https://pypi.python.org/pypi/PasteDeploy"
# pypi tarball does not include tests
SRC_URI="https://bitbucket.org/ianb/pastedeploy/get/${PV}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc test"

RDEPEND="dev-python/namespace-paste[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${P}-r1

PATCHES=(
	"${FILESDIR}"/${P}-py3-tests.patch
)

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	use doc && dodoc docs/*.txt
	find "${D}" -name '*.pth' -delete || die
}
