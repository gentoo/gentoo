# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd xdg-utils

DESCRIPTION="D-Bus abstraction for enumerating power devices, querying history and statistics"
HOMEPAGE="https://upower.freedesktop.org/"

# No tarball released, use the same commit as Fedora
#SRC_URI="https://${PN}.freedesktop.org/releases/${P}.tar.xz"
COMMIT="2282c7c0e53fb31816b824c9d1f547e8"
SRC_URI="https://gitlab.freedesktop.org/upower/upower/uploads/${COMMIT}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/3" # based on SONAME of libupower-glib.so
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 sparc x86"

# gtk-doc files are not available as prebuilt in the tarball
IUSE="doc +introspection ios kernel_FreeBSD kernel_linux selinux"

COMMON_DEPS="
	>=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.34:2
	sys-apps/dbus:=
	introspection? ( dev-libs/gobject-introspection:= )
	kernel_linux? (
		dev-libs/libgudev:=
		virtual/libusb:1
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

PATCHES=(
	# daemon: Consider pending-charge when calculating the display state
	# (from 'master')
	"${FILESDIR}/${P}-pending-charge1.patch"
	"${FILESDIR}/${P}-pending-charge2.patch"
)

src_prepare() {
	default
	xdg_environment_reset
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
		--libexecdir="${EPREFIX}"/usr/lib/${PN}
		--localstatedir="${EPREFIX}"/var
		--with-backend=${backend}
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemdutildir="$(systemd_get_utildir)"
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_with ios idevice)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	keepdir /var/lib/upower #383091
}
