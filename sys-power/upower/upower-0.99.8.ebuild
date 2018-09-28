# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit systemd xdg-utils

DESCRIPTION="D-Bus abstraction for enumerating power devices, querying history and statistics"
HOMEPAGE="https://upower.freedesktop.org/"

# No tarball released, use the same commit as Fedora
#SRC_URI="https://${PN}.freedesktop.org/releases/${P}.tar.xz"
COMMIT="9125ab7ee96fdc4ecc68cfefb50c1cab"
SRC_URI="https://gitlab.freedesktop.org/upower/upower/uploads/${COMMIT}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/3" # based on SONAME of libupower-glib.so
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

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

DOCS=( AUTHORS HACKING NEWS README )

src_prepare() {
	default
	sed -i -e '/DISABLE_DEPRECATED/d' configure || die
}

src_configure() {
	local backend

	if use kernel_linux ; then
		backend=linux
	elif use kernel_FreeBSD ; then
		backend=freebsd
	else
		backend=dummy
	fi

	local myeconfargs=(
		--disable-static
		--disable-tests
		--enable-man-pages
		--libexecdir="${EPREFIX%/}"/usr/lib/${PN}
		--localstatedir="${EPREFIX%/}"/var
		--with-backend=${backend}
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemdutildir="$(systemd_get_utildir)"
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_with ios idevice)
	)
	xdg_environment_reset
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	keepdir /var/lib/upower #383091
}
