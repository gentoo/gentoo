# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Matplotlib toolkit for gridding irreguraly spaced data"
HOMEPAGE="http://matplotlib.sourceforge.net/users/toolkits.html"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-python/matplotlib-0.98[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	insinto /usr/share/doc/${PF}
	doins test.py
	distutils-r1_python_install_all
}

python_install() {
	# namespace installed by dev-python/matplotlib
	rm "${BUILD_DIR}/lib/mpl_toolkits/__init__.py" || die
	distutils-r1_python_install --skip-build
}
