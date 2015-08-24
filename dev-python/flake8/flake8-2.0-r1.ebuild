# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="the modular source code checker: pep8, pyflakes and co"
HOMEPAGE="https://bitbucket.org/tarek/flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ppc64 x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
RDEPEND="
	>=dev-python/pyflakes-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/pep8-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.2[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test || die "Tests failed for ${EPYTHON}"
}
