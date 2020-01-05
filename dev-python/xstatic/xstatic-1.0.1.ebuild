# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN="XStatic"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XStatic base package with minimal support code"
HOMEPAGE="https://pypi.org/project/XStatic"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_install() {
	distutils-r1_python_install
	find "${ED}" -name '*.pth' -delete || die
}
