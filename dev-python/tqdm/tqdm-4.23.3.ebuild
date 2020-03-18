# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Add a progress meter to your loops in a second"
HOMEPAGE="https://github.com/tqdm/tqdm"
SRC_URI="https://github.com/tqdm/tqdm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s#man/man1#share/man/man1#" setup.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
