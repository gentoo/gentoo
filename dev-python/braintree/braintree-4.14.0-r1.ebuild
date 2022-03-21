# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Braintree Python Library"
HOMEPAGE="https://developers.braintreepayments.com/python/sdk/server/overview"
# PyPI tarballs don't contain tests
SRC_URI="https://github.com/braintree/braintree_python/archive/${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/requests-0.11.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}_python-${PV}"
DOCS=(README.md)

distutils_enable_tests nose

python_test() {
	distutils-r1_python_test tests/unit
}
