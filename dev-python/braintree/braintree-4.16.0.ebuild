# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=braintree_python-${PV}
DESCRIPTION="Braintree Python Library"
HOMEPAGE="
	https://developer.paypal.com/braintree/docs/reference/overview/
	https://github.com/braintree/braintree_python/
	https://pypi.org/project/braintree/
"
SRC_URI="
	https://github.com/braintree/braintree_python/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/requests-0.11.1[${PYTHON_USEDEP}]
"

DOCS=( README.md )

distutils_enable_tests nose

python_test() {
	nosetests -v tests/unit || die
}
