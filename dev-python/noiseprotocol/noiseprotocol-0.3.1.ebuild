# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Implementation of Noise Protocol Framework. Compatible with revisions 32 and 33."
HOMEPAGE="
	https://github.com/plizonczyk/noiseprotocol/
	https://pypi.org/project/noiseprotocol/
"
SRC_URI="
	https://github.com/plizonczyk/noiseprotocol/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	default
	rm -r "examples" || die "rm failed"
}
