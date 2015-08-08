# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-build

DESCRIPTION="The Phonon module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 arm hppa ~ia64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="dbus qt3support"

DEPEND="
	~dev-qt/qtgui-${PV}[aqua=,debug=,qt3support=]
	!kde-apps/phonon-kde
	!kde-base/phonon-xine
	!media-libs/phonon
	!media-sound/phonon
	!aqua? ( media-libs/gstreamer:0.10
		 media-plugins/gst-plugins-meta:0.10 )
	aqua? ( ~dev-qt/qtopengl-${PV}[aqua=,debug=,qt3support=] )
	dbus? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/phonon
		src/plugins/phonon"

	QT4_EXTRACT_DIRECTORIES="
		include
		src"

	QCONFIG_ADD="phonon"
	QCONFIG_DEFINE="QT_PHONON
			$(use !aqua && echo QT_GSTREAMER)"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-phonon -phonon-backend -no-opengl -no-svg
		$(qt_use dbus qdbus)
		$(qt_use qt3support)"

	qt4-build_src_configure
}
