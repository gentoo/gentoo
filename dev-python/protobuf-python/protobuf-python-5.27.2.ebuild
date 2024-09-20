# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Default implementation currently is upb, which doesn't match dev-libs/protobuf
# https://github.com/protocolbuffers/protobuf/blob/main/python/README.md#implementation-backends

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYPI_PN="protobuf"

inherit distutils-r1 pypi

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="
	https://protobuf.dev/
	https://pypi.org/project/protobuf/
"

# Rename sdist to avoid conflicts with dev-libs/protobuf
SRC_URI="
	$(pypi_sdist_url)
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-3)"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
