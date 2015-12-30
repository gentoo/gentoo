# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Objects and routines pertaining to date and time"
HOMEPAGE="https://bitbucket.org/jaraco/tempora"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# The binary calc-prorate used to be part of jaraco.util
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	!!<=dev-python/jaraco-utils-10.0.2
	>=dev-python/setuptools_scm-1.9[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}
