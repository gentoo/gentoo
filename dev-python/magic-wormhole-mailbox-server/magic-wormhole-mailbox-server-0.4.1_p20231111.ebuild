# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

# Version 0.4.1 with additional upstream fixes for python 3.12 support
EGIT_COMMIT="30ecb6e3f6f487c915e7ff0acdf2e630cbe17dc8"
MY_P=${PN}-${EGIT_COMMIT}
DESCRIPTION="Mailbox server for magic-wormhole"
HOMEPAGE="
	https://magic-wormhole.readthedocs.io/en/latest/
	https://github.com/magic-wormhole/magic-wormhole-mailbox-server/
	https://pypi.org/project/magic-wormhole-mailbox-server/
"
SRC_URI="
	https://github.com/magic-wormhole/magic-wormhole-mailbox-server/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/treq[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
