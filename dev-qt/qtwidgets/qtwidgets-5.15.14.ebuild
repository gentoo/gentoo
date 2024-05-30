# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Set of components for creating classic desktop-style UIs for the Qt5 framework"

# keep IUSE defaults in sync with qtgui
IUSE="dbus gles2-only gtk +png +X"
REQUIRED_USE="gtk? ( dbus )"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*:5=[gles2-only=,png=,X?]
	dbus? ( =dev-qt/qtdbus-${QT5_PV}* )
	gtk? (
		dev-libs/glib:2
		=dev-qt/qtgui-${QT5_PV}*:5=[dbus]
		x11-libs/gtk+:3[X]
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
	dbus:xdgdesktopportal:
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
		$(usev dbus -dbus-linked)
		$(qt_use gtk)
		-gui
		$(qt_use png libpng system)
		-widgets
		$(qt_use X xcb)
		$(usev X '-xcb-xlib -xkbcommon')
	)
	qt5-build_src_configure
}
