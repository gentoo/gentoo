# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2

DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="http://www.opencsg.org"
SRC_URI="http://www.opencsg.org/OpenCSG-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="media-libs/glew dev-qt/qtcore:4"
DEPEND="${CDEPEND} sys-devel/gcc"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/OpenCSG-${PV}"

src_prepare() {
	# removes duplicated headers
	rm -r "${S}"/glew || die

	# We actually want to install something
	cat << EOF >> src/src.pro
include.path=/usr/include
include.files=../include/*
target.path=/usr/$(get_libdir)
INSTALLS += target include
EOF

}

src_configure() {
	 eqmake4 "${S}"/src/src.pro
}
