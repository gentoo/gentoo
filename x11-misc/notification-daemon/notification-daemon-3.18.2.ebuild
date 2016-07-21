# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome.org

DESCRIPTION="Notification daemon"
HOMEPAGE="https://git.gnome.org/browse/notification-daemon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.15.2:3
	sys-apps/dbus
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS )

src_install() {
	default

	cat <<-EOF > "${T}"/org.freedesktop.Notifications.service
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}"/org.freedesktop.Notifications.service
}
