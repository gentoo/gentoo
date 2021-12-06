# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
inherit distutils-r1

DESCRIPTION="Get things from one computer to another, safely"
HOMEPAGE="
	https://github.com/magic-wormhole/magic-wormhole
	https://magic-wormhole.readthedocs.io/
"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	~dev-python/python-spake2-0.8[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-17.5.0[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.14.1[${PYTHON_USEDEP}]
	dev-python/automat[${PYTHON_USEDEP}]
	dev-python/python-hkdf[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.13.0[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	>=dev-python/txtorcon-18.0.2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}]
			net-misc/magic-wormhole-mailbox-server[${PYTHON_USEDEP}]
			net-misc/magic-wormhole-transit-relay[${PYTHON_USEDEP}] )
"

# TODO: get tests to work on first install
distutils_enable_tests setup.py
