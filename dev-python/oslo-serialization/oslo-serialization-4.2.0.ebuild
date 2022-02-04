# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

MY_P=${P/-/.}

DESCRIPTION="Oslo Serialization library"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/.}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-2.2.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx doc/source \
	dev-python/openstackdocstheme

python_prepare_all() {
	# remove spurious rdep on pbr
	sed -i -e '/pbr/d' requirements.txt || die
	distutils-r1_python_prepare_all
}
