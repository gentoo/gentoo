# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtsvg/qtsvg-4.8.5.ebuild,v 1.10 2014/01/26 11:56:09 ago Exp $

EAPI=4

inherit qt4-build

DESCRIPTION="The SVG module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="+accessibility"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[accessibility=,aqua=,debug=]
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/svg
		src/plugins/imageformats/svg
		src/plugins/iconengines/svgiconengine"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/QtSvg
		include/Qt
		include/QtGui
		include/QtCore
		include/QtXml
		src/corelib
		src/gui
		src/plugins
		src/xml
		src/3rdparty"

	QCONFIG_ADD="svg"
	QCONFIG_DEFINE="QT_SVG"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-svg
		$(qt_use accessibility)
		-no-xkb  -no-xrender
		-no-xrandr -no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm
		-no-opengl -no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff
		-no-fontconfig -no-glib -no-gtkstyle"

	qt4-build_src_configure
}
