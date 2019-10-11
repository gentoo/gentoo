# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org

DESCRIPTION="Notification daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/notification-daemon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.19.5:3[X]
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
