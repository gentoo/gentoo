# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_4,3_5} )

inherit python-r1

DESCRIPTION="Audio plugin host and sampler"
HOMEPAGE="https://github.com/falkTX/Carla"
SRC_URI="https://github.com/falkTX/Carla/archive/1.9.6.tar.gz -> carla-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/Carla-${PV}"

DEPEND="dev-python/PyQt4[${PYTHON_USEDEP}]
	media-libs/liblo
	x11-libs/fltk[static-libs]
"
RDEPEND="${DEPEND}"

src_compile() {
	emake
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}
