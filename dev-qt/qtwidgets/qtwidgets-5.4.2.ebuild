# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtwidgets/qtwidgets-5.4.2.ebuild,v 1.1 2015/06/17 15:24:18 pesa Exp $

EAPI=5
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Set of UI elements for creating classic desktop-style user interfaces for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

# keep IUSE defaults in sync with qtgui
IUSE="gles2 gtkstyle +png +xcb"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2=,gtkstyle=,png=,xcb?]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/uic
	src/widgets
)

QT5_GENTOO_CONFIG=(
	!:no-widgets:
)

src_configure() {
	local myconf=(
		$(qt_use gtkstyle)
		-opengl $(usex gles2 es2 desktop)
		$(qt_use png libpng system)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon system)
		$(use xcb && echo -xcb-xlib -xinput2 -xkb -xrender)
	)
	qt5-build_src_configure
}
