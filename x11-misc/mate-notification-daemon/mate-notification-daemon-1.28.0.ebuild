# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="MATE Notification daemon"
LICENSE="GPL-2+ GPL-3+"
SLOT="0"

IUSE="nls X wayland"
REQUIRED_USE="|| ( X wayland )"

COMMON_DEPEND="dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=dev-libs/libxml2-2.9.0
	>=sys-apps/dbus-1
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22:2
	>=x11-libs/libnotify-0.7
	>=x11-libs/gtk+-3.22:3
	>=media-libs/libcanberra-0.4:0[gtk3]
	X? (
		x11-libs/libX11
		>=x11-libs/libwnck-3:3
	)
	wayland? ( gui-libs/gtk-layer-shell )
"

RDEPEND="${COMMON_DEPEND}
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
	!x11-misc/notification-daemon
"

DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	mate-base/mate-panel
"

src_configure() {
	mate_src_configure \
		$(use_enable nls) \
		$(use_enable X x11) \
		$(use_enable wayland)
}

src_install() {
	mate_src_install

	insinto /usr/share/dbus-1/services
	doins "${FILESDIR}/org.freedesktop.Notifications.service"
}
