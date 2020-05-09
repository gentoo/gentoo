# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Set of components for creating classic desktop-style UIs for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 arm ~arm64 ~hppa ~ppc ppc64 ~sparc ~x86"
fi

# keep IUSE defaults in sync with qtgui
IUSE="gles2-only gtk +png +X"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
	~dev-qt/qtgui-${PV}[gles2-only=,png=,X?]
	gtk? (
		~dev-qt/qtgui-${PV}[dbus]
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango
	)
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/uic
	src/widgets
	src/plugins/platformthemes
)

QT5_GENTOO_CONFIG=(
	gtk:gtk3:
	::widgets
	!:no-widgets:
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:widgets
)

src_configure() {
	local myconf=(
		-opengl $(usex gles2-only es2 desktop)
		$(qt_use gtk)
		-gui
		$(qt_use png libpng system)
		-widgets
		$(qt_use X xcb system)
		$(usex X '-xcb-xlib -xcb-xinput -xkb -xkbcommon' '')
	)
	qt5-build_src_configure
}
