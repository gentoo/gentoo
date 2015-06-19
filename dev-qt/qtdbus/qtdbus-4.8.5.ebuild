# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtdbus/qtdbus-4.8.5.ebuild,v 1.10 2014/01/26 11:55:48 ago Exp $

EAPI=4

inherit qt4-build

DESCRIPTION="The DBus module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	>=sys-apps/dbus-1.2
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.7-qdbusintegrator-no-const.patch"
	"${FILESDIR}/${PN}-4.8.4-qdbusconnection-silence-warning.patch"
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/dbus
		tools/qdbus/qdbus
		tools/qdbus/qdbusxml2cpp
		tools/qdbus/qdbuscpp2xml"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/QtCore
		include/QtDBus
		include/QtXml
		src/corelib
		src/xml"

	QCONFIG_ADD="dbus dbus-linked"
	QCONFIG_DEFINE="QT_DBUS"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+=" -dbus-linked"

	qt4-build_src_configure
}
