# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 eutils

DESCRIPTION="An exotic, usable shell"
HOMEPAGE="
	https://github.com/scopatz/xonsh
	https://pypi.org/project/xonsh/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed \
		-e "/install_jupyter_hook/s:prefix=prefix:prefix=u\"${ED}/usr\":g" \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}

pkg_postinst() {
	elog "Please install"
	optfeature "Jupyter kernel support" dev-python/jupyter
	optfeature "Alternative to readline backend" dev-python/prompt_toolkit
}
