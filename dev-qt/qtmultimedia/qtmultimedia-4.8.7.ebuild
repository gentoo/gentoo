# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit qt4-build-multilib

DESCRIPTION="The Multimedia module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ~ia64 ppc ppc64 x86"
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
	"${FILESDIR}/${PN}-4.8.6-Relax-ALSA-version-checks-for-1.1.x.patch" # bug 572426
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
