# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Set of components for creating classic desktop-style UIs for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

# keep IUSE defaults in sync with qtgui
IUSE="examples gles2 gtk +png +xcb"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2=,png=,xcb?]
	gtk? (
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango
	)
"
RDEPEND="${DEPEND}"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}[gles2=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/tools/uic
	src/widgets
	src/plugins/platformthemes
)

QT5_GENTOO_CONFIG=(
	gtk:gtk3:
	!:no-widgets:
)

src_configure() {
	local myconf=(
		-opengl $(usex gles2 es2 desktop)
		$(qt_use gtk)
		$(qt_use png libpng system)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon system)
		$(usex xcb '-xcb-xlib -xinput2 -xkb' '')
	)
	qt5-build_src_configure
}
