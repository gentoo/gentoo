# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} pypy3 )

inherit distutils-r1

DESCRIPTION="Bash tab completion for argparse"
HOMEPAGE="https://pypi.org/project/argcomplete/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		<dev-python/importlib_metadata-2[${PYTHON_USEDEP}]
	' -2 python3_{5,6,7} pypy3)"
# pip is called as an external tool
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		app-shells/fish
		app-shells/tcsh
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pip
	)"

python_test() {
	"${EPYTHON}" test/test.py -v || die
}
