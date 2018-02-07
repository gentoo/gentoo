# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="A client class with support for both MQTT v3.1 and v3.1.1"
HOMEPAGE="https://www.eclipse.org/paho/clients/python/"
SRC_URI="https://github.com/eclipse/paho.mqtt.python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="dev-python/setuptools[${MULTILIB_USEDEP}]"

S="${WORKDIR}/paho.mqtt.python-${PV}"

python_prepare() {
	sed -i -e "s/python/${EPYTHON}/" test/lib/Makefile || die
}

python_test() {
	emake test
}
