# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mesonbuild/meson"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

inherit distutils-r1

DESCRIPTION="Open source build system"
HOMEPAGE="http://mesonbuild.com/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	${EPYTHON} run_tests.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/vim/vimfiles
	doins -r syntax-highlighting/vim/{ftdetect,indent,syntax}
}
