# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1 pypi

DESCRIPTION="A simple library to add cryptographic attestation to patches sent via email"
HOMEPAGE="https://pypi.org/project/patatt/"
SRC_URI="https://www.kernel.org/pub/software/devel/patatt/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="dev-python/pynacl[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
