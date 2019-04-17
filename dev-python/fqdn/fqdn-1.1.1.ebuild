# Copyright 2018 Sony Interactive Entertainment Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit distutils-r1

DESCRIPTION="RFC-compliant FQDN validation and manipulation for Python"
HOMEPAGE="https://github.com/guyhughes/fqdn"
SRC_URI="https://github.com/guyhughes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/cached-property[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_test() {
	esetup.py test
}
