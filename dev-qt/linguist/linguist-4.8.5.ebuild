# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/linguist/linguist-4.8.5.ebuild,v 1.12 2014/01/26 11:55:30 ago Exp $

EAPI=5

inherit eutils qt4-build

DESCRIPTION="Graphical tool for translating Qt applications"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE=""

DEPEND="
	~dev-qt/designer-${PV}[aqua=,debug=]
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=]
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="tools/linguist/linguist"
	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools"

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

src_install() {
	qt4-build_src_install

	newicon tools/linguist/linguist/images/icons/linguist-128-32.png linguist.png
	make_desktop_entry linguist Linguist linguist 'Qt;Development;Translation'
}
