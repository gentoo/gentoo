# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

AT_M4DIR="build/autotools/"

inherit autotools python

DESCRIPTION="Python bindings for the libmemphis library"
HOMEPAGE="http://gitorious.net/pymemphis"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
IUSE=""

RDEPEND="
	dev-python/pycairo
	dev-python/pygobject:2
	media-libs/memphis"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-mainline

src_prepare() {
	eautoreconf
	echo "#!${EPREFIX}/bin/sh" > py-compile
	sed 's:0.1:0.2:g' -i pymemphis.pc.in || die
	python_src_prepare
}

src_install() {
	python_src_install
	python_clean_installation_image
	dodoc AUTHORS ChangeLog README || die
}
