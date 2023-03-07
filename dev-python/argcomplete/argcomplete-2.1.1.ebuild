# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Bash tab completion for argparse"
HOMEPAGE="
	https://github.com/kislyuk/argcomplete/
	https://pypi.org/project/argcomplete/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# pip is called as an external tool
BDEPEND="
	test? (
		app-shells/fish
		app-shells/tcsh
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pip-19
	)
"

src_prepare() {
	sed -i -e 's:timeout=5:timeout=30:' test/test.py || die
	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" test/test.py -v || die
}
