# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1 eutils

DESCRIPTION="An exotic, usable shell"
HOMEPAGE="
	http://xonsh.readthedocs.org/
	https://github.com/scopatz/xonsh
	http://pypi.python.org/pypi/xonsh"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed \
		-e "/install_kernel_spec/s:prefix=None:prefix=u\"${ED}/usr\":g" \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}

pkg_postinst() {
	optfeature "Jupyter kernel support" dev-python/jupyter
	optfeature "Alternative to readline backend" dev-python/prompt_toolkit
}
