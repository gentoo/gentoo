# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openscad/openscad-2013.06.ebuild,v 1.3 2013/09/16 09:44:38 scarabeus Exp $

EAPI=5

inherit qt4-r2

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
SRC_URI="https://openscad.googlecode.com/files/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="media-gfx/opencsg
	sci-mathematics/cgal
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-cpp/eigen:2
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
