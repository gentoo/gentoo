# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 pypi

DESCRIPTION="Tool to compare ELF binaries"
HOMEPAGE="https://github.com/noseglasses/elf_diff https://pypi.org/project/elf_diff"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
# Tests fail for now but probably gone unnoticed as its exit status was
# wrong on failure.
RESTRICT="!test? ( test ) test"

RDEPEND="
	dev-python/anytree[${PYTHON_USEDEP}]
	dev-python/dict2xml[${PYTHON_USEDEP}]
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/progressbar2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/weasyprint[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/deepdiff[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.1-test-runner-exit.patch
)

python_test() {
	"${EPYTHON}" tests/test_main.py -p || die "Tests failed with ${EPYTHON}"
}
