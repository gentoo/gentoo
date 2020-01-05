# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Framework for Unix-like command line programs"
HOMEPAGE="http://liw.fi/cliapp/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/cliapp/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_test() {
	addwrite /proc/self/comm
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" -m unittest discover -v -p '*_tests.py' || die
}
