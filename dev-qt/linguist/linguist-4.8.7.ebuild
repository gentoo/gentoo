# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qt4-build-multilib

DESCRIPTION="Graphical tool for translating Qt applications"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE=""

DEPEND="
	~dev-qt/designer-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="tools/linguist/linguist"

multilib_src_configure() {
	local myconf=(
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	newicon tools/linguist/linguist/images/icons/linguist-128-32.png linguist.png
	make_desktop_entry linguist Linguist linguist 'Qt;Development;Translation'
}
