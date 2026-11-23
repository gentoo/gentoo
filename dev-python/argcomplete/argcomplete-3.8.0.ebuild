# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/kislyuk/argcomplete
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Bash tab completion for argparse"
HOMEPAGE="
	https://github.com/kislyuk/argcomplete/
	https://pypi.org/project/argcomplete/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# pip is called as an external tool
# setuptools is needed for package tests
# zsh pin: https://github.com/kislyuk/argcomplete/issues/544
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		app-shells/tcsh
		app-shells/zsh
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pip-19
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# run pip tests without build isolation, so it doesn't download
	# setuptools
	"${FILESDIR}/argcomplete-3.8.0-no-build-isolation.patch"
)

src_prepare() {
	distutils-r1_src_prepare

	# increase test timeouts
	sed -i -e 's:timeout=5:timeout=30:' test/test.py || die
}

python_test() {
	"${EPYTHON}" test/test.py -v || die
}
