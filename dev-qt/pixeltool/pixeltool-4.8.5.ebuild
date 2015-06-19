# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/pixeltool/pixeltool-4.8.5.ebuild,v 1.11 2014/01/26 11:55:33 ago Exp $

EAPI=5

inherit qt4-build

DESCRIPTION="Qt screen magnifier"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=]
	!<dev-qt/qthelp-4.8.5:4
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="tools/pixeltool"
	QT4_EXTRACT_DIRECTORIES="
		include
		src/corelib
		src/gui
		tools/pixeltool"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl"

	qt4-build_src_configure
}
