# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="OpenStack Client Configuation Library"
HOMEPAGE="http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/requestsexceptions-1.1.1[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/test_get_all_clouds.patch
)

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
