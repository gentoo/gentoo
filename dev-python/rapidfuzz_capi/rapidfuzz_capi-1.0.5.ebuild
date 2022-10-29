# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="C-API of RapidFuzz, which can be used to extend RapidFuzz"
HOMEPAGE="
	https://github.com/maxbachmann/rapidfuzz_capi/
	https://pypi.org/project/rapidfuzz-capi/
"
SRC_URI="
	https://github.com/maxbachmann/rapidfuzz_capi/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv"
