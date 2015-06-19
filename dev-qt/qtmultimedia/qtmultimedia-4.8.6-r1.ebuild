# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtmultimedia/qtmultimedia-4.8.6-r1.ebuild,v 1.6 2015/05/30 11:06:09 maekke Exp $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The Multimedia module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="arm ppc ppc64"
else
	KEYWORDS="amd64 arm ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
fi

IUSE="alsa"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.8.0-alsa.patch"
)

QT4_TARGET_DIRECTORIES="src/multimedia"

QCONFIG_ADD="multimedia"
QCONFIG_DEFINE="QT_MULTIMEDIA"

multilib_src_configure() {
	local myconf=(
		-multimedia -audio-backend
		$(qt_use alsa)
		-no-accessibility -no-qt3support -no-xmlpatterns -no-phonon -no-phonon-backend
		-no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg -no-openssl
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
	)
	qt4_multilib_src_configure
}
