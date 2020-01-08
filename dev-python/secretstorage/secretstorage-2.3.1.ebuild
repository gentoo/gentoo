# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

MY_PN="SecretStorage"

DESCRIPTION="Python bindings to FreeDesktop.org Secret Service API."
HOMEPAGE="https://github.com/mitya57/secretstorage https://pypi.org/project/SecretStorage/"
SRC_URI="mirror://pypi/S/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}"
