# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

DESCRIPTION="Secure, decentralized, data store"
HOMEPAGE="https://tahoe-lafs.org/trac/tahoe-lafs"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tahoe-lafs/tahoe-lafs.git"
else
	SRC_URI="https://tahoe-lafs.org/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-18.2.0[${PYTHON_USEDEP}]
	>=dev-python/autobahn-19.5.2[${PYTHON_USEDEP}]
	>=dev-python/bcrypt-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/characteristic-14.0.0[${PYTHON_USEDEP}]
	dev-python/collections-extended[${PYTHON_USEDEP}]
	>=dev-python/distro-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	>=dev-python/eliot-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/foolscap-21.7[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/klein[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.8[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.6[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/pyutil-3.3.0[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/treq[${PYTHON_USEDEP}]
	>=dev-python/twisted-19.10.0[${PYTHON_USEDEP}]
	>=dev-python/zfec-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.6.0[${PYTHON_USEDEP}]
	>=net-misc/magic-wormhole-0.10.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/prometheus_client[${PYTHON_USEDEP}]
		dev-python/pytest-twisted[${PYTHON_USEDEP}]
		dev-python/tenacity[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs \
	dev-python/recommonmark dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
