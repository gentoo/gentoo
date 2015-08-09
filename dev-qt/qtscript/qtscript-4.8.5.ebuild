# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-build

DESCRIPTION="The QtScript module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="iconv +jit"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/4.8.2-javascriptcore-x32.patch" )

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/script"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/Qt
		include/QtCore
		include/QtScript
		src/3rdparty/javascriptcore
		src/corelib"

	QCONFIG_ADD="script"
	QCONFIG_DEFINE="QT_SCRIPT"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		$(qt_use iconv)
		$(qt_use jit javascript-jit)
		-no-xkb -no-fontconfig -no-xrender -no-xrandr -no-xfixes -no-xcursor -no-xinerama
		-no-xshape -no-sm -no-opengl -no-nas-sound -no-dbus -no-cups -no-nis -no-gif
		-no-libpng -no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff
		-no-accessibility -no-fontconfig -no-glib -no-opengl -no-svg
		-no-gtkstyle"

	qt4-build_src_configure
}

src_install() {
	qt4-build_src_install

	# install private headers
	insinto "${QTHEADERDIR#${EPREFIX}}"/QtScript/private
	find "${S}"/src/script -type f -name "*_p.h" -exec doins {} +
}
