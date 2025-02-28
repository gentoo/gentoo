# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A python module for the axolotl protocol"
HOMEPAGE="
	https://github.com/tgalal/python-axolotl/
	https://pypi.org/project/python-axolotl/
"
SRC_URI="
	https://github.com/tgalal/python-axolotl/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/parona-source/python-axolotl/commit/f23e151c2f27043c7261eb07dd50f269abf51dce.patch
		-> python-axolotl-0.2.3-update-proto.patch
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv x86"

PATCHES=(
	# https://bugs.gentoo.org/936053
	# https://github.com/tgalal/python-axolotl/pull/46
	"${DISTDIR}"/python-axolotl-0.2.3-update-proto.patch
)

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.20[${PYTHON_USEDEP}]
	dev-python/python-axolotl-curve25519[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
