# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/kislyuk/argcomplete
PYTHON_COMPAT=( python3_{12..15} )

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
		~app-shells/zsh-5.9
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pip-19
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# increase test timeouts -- this is particularly necessary
	# for entry point tests because they read metadata of all installed
	# packages which can take real long on systems with lots of packages
	"${FILESDIR}/argcomplete-3.1.6-timeout.patch"

	# run pip tests without build isolation, so they don't download
	# setuptools
	"${FILESDIR}/argcomplete-3.7.0-no-build-isolation.patch"
)

python_test() {
	"${EPYTHON}" test/test.py -v || die
}
