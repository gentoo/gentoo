# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A password strength measuring library"
HOMEPAGE="https://pypi.org/project/passwordmeter/ https://github.com/cadithealth/passwordmeter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/asset-0.6.3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed \
		-e '/distribute/d' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}
