# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qdbusviewer/qdbusviewer-4.8.6-r1.ebuild,v 1.8 2015/08/06 13:52:35 zlogene Exp $

EAPI=5

inherit eutils qt4-build-multilib

DESCRIPTION="Graphical tool that lets you introspect D-Bus objects and messages"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm hppa ia64 ppc ppc64"
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtdbus-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="tools/qdbus/qdbusviewer"

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

	newicon tools/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer.png
	make_desktop_entry qdbusviewer QDBusViewer qdbusviewer 'Qt;Development'
}
