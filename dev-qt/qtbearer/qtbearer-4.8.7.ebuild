# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-build-multilib

DESCRIPTION="The network bearer plugins for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="connman networkmanager"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	connman? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	networkmanager? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/plugins/bearer/generic
		$(use connman && echo src/plugins/bearer/connman)
		$(use networkmanager && echo src/plugins/bearer/networkmanager)"
}

multilib_src_configure() {
	local myconf=(
		$(use connman || use networkmanager || echo -no-dbus)
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg
		-no-cups -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
	)
	qt4_multilib_src_configure
}
