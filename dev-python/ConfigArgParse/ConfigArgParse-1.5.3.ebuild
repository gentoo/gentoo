# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for argparse supporting config files and env variables"
HOMEPAGE="
	https://github.com/bw2/ConfigArgParse/
	https://pypi.org/project/ConfigArgParse/"
SRC_URI="
	https://github.com/bw2/ConfigArgParse/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_test() {
	local -x COLUMNS=80
	distutils-r1_src_test
}
