# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

MY_PN=${PN/-/.}

DESCRIPTION="Oslo Serialization library"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# allow useage of renamed msgpack
	sed -i '/^msgpack/d' requirements.txt || die
	distutils-r1_python_prepare_all
}
