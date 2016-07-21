# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# FIXME: MakeSwig.py execution should be made work from pyfltk-1.1.5.ebuild

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic

MY_P=pyFltk-${PV}

DESCRIPTION="Python interface to Fltk library"
HOMEPAGE="http://pyfltk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="doc"

DEPEND=">=x11-libs/fltk-1.3.0:1[opengl]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-linux-3.x-detection.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/ignore-func.patch
	"${FILESDIR}"/fltk_wrap.patch
	)

python_prepare_all() {
	# Disable installation of documentation and tests.
	sed -i -e '/package_data=/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_install_all() {
	use doc && local HTML_DOCS=( fltk/docs/. )
	distutils-r1_python_install_all
}
