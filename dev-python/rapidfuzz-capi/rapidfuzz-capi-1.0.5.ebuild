# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=rapidfuzz_capi-${PV}
DESCRIPTION="C-API of RapidFuzz, which can be used to extend RapidFuzz"
HOMEPAGE="
	https://github.com/maxbachmann/rapidfuzz_capi/
	https://pypi.org/project/rapidfuzz-capi/
"
SRC_URI="
	https://github.com/maxbachmann/rapidfuzz_capi/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
