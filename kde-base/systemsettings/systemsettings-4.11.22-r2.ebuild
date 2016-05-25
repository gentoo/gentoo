# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
OPENGL_REQUIRED="optional"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde4-meta

DESCRIPTION="System settings utility"
HOMEPAGE+=" https://userbase.kde.org/System_Settings"
IUSE="debug gtk +kscreen +usb"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

COMMONDEPEND="
	dev-libs/glib:2
	$(add_kdebase_dep kwin)
	$(add_kdebase_dep libkworkspace)
	media-libs/fontconfig
	>=media-libs/freetype-2
	>=x11-libs/libxklavier-3.2
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXtst
	opengl? ( virtual/opengl )
	usb? ( virtual/libusb:0 )
"
DEPEND="${COMMONDEPEND}
	x11-proto/kbproto
	x11-proto/xextproto
"
RDEPEND="${COMMONDEPEND}
	sys-libs/timezone-data
	x11-apps/setxkbmap
	x11-misc/xkeyboard-config
	gtk? ( kde-misc/kde-gtk-config )
	kscreen? ( kde-misc/kscreen:4 )
	|| ( $(add_kdebase_dep legacy-icons) >=kde-frameworks/oxygen-icons-5.19.0:5 )
"

KMEXTRA="
	kcontrol/
"
KMEXTRACTONLY="
	krunner/dbus/org.kde.krunner.App.xml
	krunner/dbus/org.kde.screensaver.xml
	ksmserver/screenlocker/dbus/org.kde.screensaver.xml
	kwin/
	libs/
	plasma/
"
# fails to connect to a kded instance
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-kcm-randr.patch"
)

src_unpack() {
	if use handbook; then
		KMEXTRA+="
			doc/kcontrol
			doc/kfontview
		"
	fi

	kde4-meta_src_unpack
}

src_prepare() {
	eapply "${FILESDIR}/${P}-strigi-removal.patch"

	sed -i -e 's/systemsettingsrc DESTINATION ${SYSCONF_INSTALL_DIR}/systemsettingsrc DESTINATION ${CONFIG_INSTALL_DIR}/' \
		systemsettings/CMakeLists.txt \
		|| die "Failed to fix systemsettingsrc install location"

	sed -i -e '/kde4_install_icons/ s/^/#/' kcontrol/kfontinst/kio/CMakeLists.txt \
		|| die "Failed to disable icons"

	kde4-meta_src_prepare
}

# FIXME: is have_openglxvisual found without screensaver
src_configure() {
	# Old keyboard-detection code is unmaintained,
	# so we force the new stuff, using libxklavier.
	local mycmakeargs=(
		-DUSE_XKLAVIER=ON
		-DWITH_LibXKlavier=ON
		-DWITH_GLIB2=ON
		-DWITH_GObject=ON
		-DBUILD_KCM_RANDR=$(usex !kscreen)
		-DWITH_OpenGL=$(usex opengl)
		-DWITH_USB=$(usex usb)
	)

	kde4-meta_src_configure
}
