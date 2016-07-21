# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-build-multilib

DESCRIPTION="The Phonon module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
fi

IUSE="dbus qt3support"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	aqua? ( ~dev-qt/qtopengl-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}] )
	!aqua? (
		>=media-libs/gstreamer-0.10.36-r1:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-meta-0.10-r9:0.10[${MULTILIB_USEDEP}]
	)
	dbus? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	!kde-apps/phonon-kde
	!media-libs/phonon
	!media-libs/phonon-gstreamer
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/phonon
	src/plugins/phonon"

QCONFIG_ADD="phonon"

pkg_setup() {
	QCONFIG_DEFINE="
		QT_PHONON
		$(use aqua || echo QT_GSTREAMER)"
}

multilib_src_configure() {
	local myconf=(
		-phonon -phonon-backend
		-no-opengl -no-svg
		$(qt_use dbus qdbus)
		$(qt_use qt3support)
	)
	qt4_multilib_src_configure
}
