# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="OpenStack Client Configuation Library"
HOMEPAGE="https://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/openstacksdk-0.13.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/test_get_all_clouds.patch
)
