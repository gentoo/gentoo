# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit ltprune systemd

DESCRIPTION="D-Bus abstraction for enumerating power devices, querying history and statistics"
HOMEPAGE="https://upower.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/3" # based on SONAME of libupower-glib.so
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

# gtk-doc files are not available as prebuilt in the tarball
IUSE="doc +introspection ios kernel_FreeBSD kernel_linux selinux"

COMMON_DEPS="
	>=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.34:2
	sys-apps/dbus:=
	introspection? ( dev-libs/gobject-introspection:= )
	kernel_linux? (
		virtual/libusb:1
		virtual/libgudev:=
		virtual/udev
		ios? (
			>=app-pda/libimobiledevice-1:=
			>=app-pda/libplist-1:=
			)
		)
"
RDEPEND="
	${COMMON_DEPS}
	selinux? ( sec-policy/selinux-devicekit )
"
DEPEND="${COMMON_DEPS}
	doc? ( dev-util/gtk-doc )
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	dev-util/intltool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

QA_MULTILIB_PATHS="usr/lib/${PN}/.*"

DOCS="AUTHORS HACKING NEWS README"

PATCHES=(
	# Fix calling the wrong _complete_ function for up_daemon_get_critical_action()
	# (from 'master')
	"${FILESDIR}"/${P}-copy-paste.patch

	# Do not spin in a loop when /proc/timer_stats cannot be written
	# (from 'master')
	"${FILESDIR}"/${P}-timer-stats.patch
)

src_prepare() {
	default
	sed -i -e '/DISABLE_DEPRECATED/d' configure || die
}

src_configure() {
	local backend myconf

	if use kernel_linux; then
		backend=linux
	elif use kernel_FreeBSD; then
		backend=freebsd
	else
		backend=dummy
	fi

	econf \
		$(use_enable doc gtk-doc) \
		--libexecdir="${EPREFIX}"/usr/lib/${PN} \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable introspection) \
		--disable-static \
		${myconf} \
		--enable-man-pages \
		--disable-tests \
		--with-backend=${backend} \
		$(use_with ios idevice) \
		--with-systemdutildir="$(systemd_get_utildir)" \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default
	keepdir /var/lib/upower #383091
	prune_libtool_files
}
