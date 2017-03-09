# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/g/G}

inherit qmake-utils

DESCRIPTION="Qt-Frontend to load and convert gps tracks with gpsbabel"
HOMEPAGE="http://gebabbel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-Src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4[accessibility]
"
RDEPEND="${DEPEND}
	sci-geosciences/gpsbabel
"

DOCS=( CHANGELOG CREDITS )

PATCHES=( "${FILESDIR}"/${PN}-0.3-gcc45.patch )

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	# do not mess with cflags
	sed \
		-e "/QMAKE_CXXFLAGS/s:=.*$:= ${CXXFLAGS}:g" \
		-i *.pro || die
}

src_configure() {
	eqmake4 Gebabbel.pro
}

src_install() {
	dobin bin/${PN}
	einstalldocs
}
