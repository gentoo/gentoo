# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openscad/openscad-2014.03.ebuild,v 1.1 2014/05/05 18:38:19 mattm Exp $

EAPI=5

inherit qt4-r2

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
SRC_URI="http://files.openscad.org/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="media-gfx/opencsg
	sci-mathematics/cgal
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-cpp/eigen:3
	dev-libs/gmp
	dev-libs/mpfr
	dev-libs/boost:=
	sys-libs/glibc
"
DEPEND="${CDEPEND} sys-devel/gcc"
RDEPEND="${CDEPEND}"

src_prepare() {
	#Use our CFLAGS (specifically don't force x86)
	sed -i "s/QMAKE_CXXFLAGS_RELEASE = .*//g" ${PN}.pro

	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro
}
