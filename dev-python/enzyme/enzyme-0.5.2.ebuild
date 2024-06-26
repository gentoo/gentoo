# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1 pypi

DESCRIPTION="Python video metadata parser"
HOMEPAGE="
	https://github.com/Diaoul/enzyme/
	https://pypi.org/project/enzyme/
"
SRC_URI+="
	test? (
		https://downloads.sourceforge.net/matroska/test_files/matroska_test_w1_1.zip
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="
	test? (
		app-arch/unzip
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_unpack() {
	unpack "${P}.tar.gz"

	if use test; then
		mkdir -p "${P}"/tests/data || die
		cd "${P}"/tests/data || die
		unpack matroska_test_w1_1.zip
	fi
}
