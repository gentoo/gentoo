# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Setuptools plugin that makes unit tests execute with trial instead of pyunit"
HOMEPAGE="https://github.com/rutsky/setuptools-trial https://pypi.python.org/pypi/setuptools_trial"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="test"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' python2_7)
"

DEPEND="
	${RDEPEND}
"

# tests fail due to pip install sandbox violations
#	test? (
#		dev-python/virtualenv[${PYTHON_USEDEP}]
#		dev-python/pytest[${PYTHON_USEDEP}]
#		dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
#	)
#"

#python_test() {
	#distutils_install_for_testing

	#esetup.py test || die "Tests failed under ${EPYTHON}"
#}
