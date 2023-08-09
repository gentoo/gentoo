# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

# Version 0.12.0 with additional upstream fixes for python 3.11 support and
# miscellanous improvements
COMMIT_SHA1="8af8888d171791943b9fab036f0e0067b87c9b59"

inherit distutils-r1

DESCRIPTION="Get Things From One Computer To Another, Safely"
HOMEPAGE="https://magic-wormhole.readthedocs.io/en/latest/ https://pypi.org/project/magic-wormhole/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_SHA1}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/magic-wormhole-${COMMIT_SHA1}"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/automat[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/noiseprotocol[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/spake2[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
	dev-python/txtorcon[${PYTHON_USEDEP}]"

#
# magic-wormhole-0.12.0_p20230525 requires the released
# magic-wormhole-transit-relay-0.21 for setting up its unit tests. This
# hopefully will be resolved soon with the upcoming releases (of wormhole,
# mailbox-server, and transit-relay).
#
BDEPEND="
	test? (
		dev-python/magic-wormhole-mailbox-server[${PYTHON_USEDEP}]
		~dev-python/magic-wormhole-transit-relay-0.2.1[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
