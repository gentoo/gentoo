# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

MY_PN=ViTables
MY_P=${MY_PN}-${PV}

inherit distutils eutils

DESCRIPTION="A graphical tool for browsing and editing files in both PyTables and HDF5 formats"
HOMEPAGE="http://vitables.org/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-python/pytables
	dev-python/PyQt4[X]"  # FIXME: check if any other useflags are needed
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-docs.patch
}

src_compile() {
	distutils_src_compile
	if use doc; then
		# fixme: multiple python (anyone cares?)
	   python setup.py build_sphinx || die
	fi
}

src_install() {
	dodir /usr/share/icons/hicolor/scalable/apps
	dodir /usr/share/applications
	XDG_DATA_DIRS="${ED}/usr/share" distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
	use doc && dohtml -r build/sphinx/html/* && \
		dodoc build/sphinx/latex/*.pdf
}
