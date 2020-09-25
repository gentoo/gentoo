# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_P=ViTables-${PV}

DESCRIPTION="A graphical tool for browsing / editing files in both PyTables and HDF5 formats"
HOMEPAGE="https://vitables.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_MULTI_USEDEP}]
		dev-python/pytables[${PYTHON_MULTI_USEDEP}]
		dev-python/QtPy[gui,${PYTHON_MULTI_USEDEP}]
	')"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	# remove the PyQt5 dependency
	# because PyQt5 in Gentoo does not provide egg-info
	# see also: https://github.com/pyqt/python-qt5/issues/18
	sed "s:'PyQt5 [^ ]*::" -i setup.py || die

	distutils-r1_python_prepare_all
}
