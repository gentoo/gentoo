# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

MY_PN="Flask-Testing"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Unit testing for Flask"
HOMEPAGE="http://pythonhosted.org/Flask-Testing/ https://pypi.python.org/pypi/Flask-Testing/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/twill[${PYTHON_USEDEP}]' 'python2*')"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/blinker[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	local exclude
	if $(python_is_python3); then
		# Twill is not available on python-3
		exclude="-e twill"
	fi
	# test phase appears to run only py2.7 but if it passes for py2.7 is passes for pypy
	nosetests ${exclude} || die "Testing failed with ${EPYTHON}"
}
