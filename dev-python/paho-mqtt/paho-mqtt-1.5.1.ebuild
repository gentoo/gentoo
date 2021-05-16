# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A client class with support for MQTT v5.0, v3.1.1, and v3.1"
HOMEPAGE="https://www.eclipse.org/paho/index.php?page=clients/python https://github.com/eclipse/paho.mqtt.python"
SRC_URI="https://github.com/eclipse/paho.mqtt.python/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/paho.mqtt.python-${PV}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND=""
DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	) "

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-strip-test-dependency.patch"
)
