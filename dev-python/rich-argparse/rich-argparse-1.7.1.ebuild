# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Rich help formatters for argparse and optparse"
HOMEPAGE="
	https://github.com/hamdanal/rich-argparse/
	https://pypi.org/project/rich-argparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ppc64 ~riscv ~s390 x86"

RDEPEND="
	>=dev-python/rich-11.0.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local -x COLUMNS=80
	epytest
}
