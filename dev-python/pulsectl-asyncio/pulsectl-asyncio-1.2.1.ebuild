# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Asyncio frontend for pulsectl, Python bindings of libpulse"
HOMEPAGE="
	https://github.com/mhthies/pulsectl-asyncio/
	https://pypi.org/project/pulsectl-asyncio/
"
# sdist is missing examples that are used in tests
SRC_URI="
	https://github.com/mhthies/pulsectl-asyncio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	>=dev-python/pulsectl-23.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		media-sound/pulseaudio-daemon
	)
"

distutils_enable_tests pytest

src_prepare() {
	# unpin deps
	sed -i -e 's:,<=[0-9.]*::' setup.cfg || die
	distutils-r1_src_prepare
}
