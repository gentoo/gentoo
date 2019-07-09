# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Helper library for the Twilio API"
HOMEPAGE="https://github.com/twilio/twilio-python http://www.twilio.com/docs/python/install"
SRC_URI="https://github.com/twilio/${PN}-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86""
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	dev-python/PySocks[$(python_gen_usedep python3_{5,6,7})]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nosexcover[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mccabe[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/mock-0.8.0[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${PN}-python-${PV}

python_test() {
	nosetests tests || die "Tests fail with ${EPYTHON}"
}
