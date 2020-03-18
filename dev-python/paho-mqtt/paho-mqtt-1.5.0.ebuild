# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A client class with support for both MQTT v3.1 and v3.1.1"
HOMEPAGE="https://www.eclipse.org/paho/clients/python/"
SRC_URI="https://github.com/eclipse/paho.mqtt.python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	) "

S="${WORKDIR}/paho.mqtt.python-${PV}"

src_prepare() {
	eapply "${FILESDIR}/${P}-strip-test-dependency.patch"
	default
}

python_test() {
	esetup.py test
}
