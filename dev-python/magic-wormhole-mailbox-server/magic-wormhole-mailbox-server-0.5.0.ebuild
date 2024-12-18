# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Mailbox server for magic-wormhole"
HOMEPAGE="
	https://magic-wormhole.readthedocs.io/en/latest/
	https://github.com/magic-wormhole/magic-wormhole-mailbox-server/
	https://pypi.org/project/magic-wormhole-mailbox-server/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/treq[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm versioneer.py || die
}
