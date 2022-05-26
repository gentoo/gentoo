# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="An OpenGL billards game"
HOMEPAGE="https://sourceforge.net/projects/billardgl/"
SRC_URI="mirror://sourceforge/${PN}/BillardGL-${PV}.tar.gz
	mirror://gentoo/${PN}.png"
S="${WORKDIR}"/BillardGL-${PV}/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/freeglut
	x11-libs/libXi
	x11-libs/libXmu
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e "s:/usr/share/BillardGL/:/usr/share/${PN}/:" \
		Namen.h || die "sed Namen.h failed"

	sed -i \
		-e '/^LINK/s:g++:$(CXX):' \
		-e '/^CXX[[:space:]]/d' \
		-e '/^CC[[:space:]]/d' \
		-e '/^CXXFLAGS/s:=.*\(-D.*\)-.*:+=\1:' \
		-e "/^LFLAGS/s:=:=${LDFLAGS}:" \
		Makefile || die "sed Makefile failed"

	sed -i \
		-e 's:<iostream.h>:<iostream>:' \
		-e 's:<fstream.h>:<fstream>\nusing namespace std;:' \
		bmp.cpp || die "sed bmp.cpp failed"
}

src_install() {
	newbin BillardGL ${PN}

	insinto /usr/share/${PN}
	doins -r lang Texturen
	dodoc README
	doicon "${DISTDIR}"/${PN}.png

	make_desktop_entry ${PN} BillardGL
}
