# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Automation Library for Denon AVR receivers"
HOMEPAGE="https://github.com/scarface-4711/denonavr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		${RDEPEND}
	)
"

python_test() {
	py.test ||  die "tests failed with ${EPYTHON}"
}
