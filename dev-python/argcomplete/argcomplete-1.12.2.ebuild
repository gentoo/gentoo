# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Bash tab completion for argparse"
HOMEPAGE="https://pypi.org/project/argcomplete/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		<dev-python/importlib_metadata-3[${PYTHON_USEDEP}]
	' -2 python3_{5,6,7} pypy3)"
# pip is called as an external tool
BDEPEND="
	test? (
		app-shells/fish
		app-shells/tcsh
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pip-19
	)"

python_test() {
	"${EPYTHON}" test/test.py -v || die
}
