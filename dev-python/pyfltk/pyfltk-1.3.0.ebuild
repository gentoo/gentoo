# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyfltk/pyfltk-1.3.0.ebuild,v 1.5 2012/02/20 14:27:11 patrick Exp $

# FIXME: MakeSwig.py execution should be made work from pyfltk-1.1.5.ebuild

EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-**"

inherit distutils eutils

MY_P=pyFltk-${PV}

DESCRIPTION="Python interface to Fltk library"
HOMEPAGE="http://pyfltk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

DEPEND=">=x11-libs/fltk-1.3.0:1[opengl]"
RDEPEND="${DEPEND}"

PYTHON_CXXFLAGS=("2.* + -fno-strict-aliasing")

DOCS="CHANGES README TODO"
PYTHON_MODNAME="fltk"

S=${WORKDIR}/${MY_P}

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}"/${P}-linux-3.x-detection.patch

	# Disable installation of documentation and tests.
	sed -i -e '/package_data=/d' setup.py || die
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml fltk/docs/*
	fi

}
