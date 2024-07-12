# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for argparse supporting config files and env variables"
HOMEPAGE="
	https://github.com/bw2/ConfigArgParse/
	https://pypi.org/project/ConfigArgParse/"
SRC_URI="
	https://github.com/bw2/ConfigArgParse/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

PATCHES=(
	# https://github.com/bw2/ConfigArgParse/pull/295
	"${FILESDIR}/${P}-py313.patch"
)

src_test() {
	local -x COLUMNS=80
	distutils-r1_src_test
}
