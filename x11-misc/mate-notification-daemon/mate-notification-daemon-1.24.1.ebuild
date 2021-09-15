# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="MATE Notification daemon"
LICENSE="GPL-2+ GPL-3+"
SLOT="0"

IUSE=""

COMMON_DEPEND="dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=dev-libs/libxml2-2.9.0
	>=sys-apps/dbus-1
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22:2
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	virtual/libintl
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libwnck-3:3
	>=media-libs/libcanberra-0.4:0[gtk3]
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
	!x11-misc/notification-daemon
"

DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig
"

src_install() {
	mate_src_install

	insinto /usr/share/dbus-1/services
	doins "${FILESDIR}/org.freedesktop.Notifications.service"
}
