# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=ViTables-${PV}

DESCRIPTION="A graphical tool for browsing / editing files in both PyTables and HDF5 formats"
HOMEPAGE="http://vitables.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-python/pytables[${PYTHON_USEDEP}]
	dev-python/PyQt4[X,${PYTHON_USEDEP}]"  # FIXME: check if any other useflags are needed
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-no-docs.patch )

python_compile_all() {
	# fixme: multiple python (anyone cares?)
	use doc && esetup.py build_sphinx
}

python_install_all() {
	dodir /usr/share/icons/hicolor/scalable/apps
	dodir /usr/share/applications

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		DOCS+=( examples )
	fi
	if use doc; then
		HTML_DOCS+=( "${BUILD_DIR}"/sphinx/html/. )
		DOCS+=( "${BUILD_DIR}"/sphinx/latex/*.pdf )
	fi
	distutils-r1_python_install_all
}
