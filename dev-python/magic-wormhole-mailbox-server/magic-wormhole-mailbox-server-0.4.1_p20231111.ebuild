# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

# Version 0.4.1 with additional upstream fixes for python 3.12 support
COMMIT_SHA1="30ecb6e3f6f487c915e7ff0acdf2e630cbe17dc8"

inherit distutils-r1

DESCRIPTION="Mailbox server for magic-wormhole"
HOMEPAGE="https://magic-wormhole.readthedocs.io/en/latest/ https://pypi.org/project/magic-wormhole-mailbox-server/"
SRC_URI="https://github.com/magic-wormhole/${PN}/archive/${COMMIT_SHA1}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
S="${WORKDIR}/magic-wormhole-mailbox-server-${COMMIT_SHA1}"

RDEPEND="
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/treq[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
