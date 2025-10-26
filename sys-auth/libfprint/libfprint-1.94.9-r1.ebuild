# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson udev

MY_P="${PN}-v${PV}"

DESCRIPTION="Library to add support for consumer fingerprint readers"
HOMEPAGE="
	https://fprint.freedesktop.org/
	https://gitlab.freedesktop.org/libfprint/libfprint
"
SRC_URI="
	!tod? (
		https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2
	)
	tod? (
		https://gitlab.freedesktop.org/3v1n0/${PN}/-/archive/v${PV}+tod1/${MY_P}+tod1.tar.bz2 -> ${P}+tod1.tar.bz2
	)
"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples gtk-doc +introspection tod"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev
	>=dev-libs/openssl-3:=
	dev-python/pygobject
	dev-libs/libgusb
	x11-libs/pixman
	examples? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? (
		>=dev-libs/gobject-introspection-1.82.0-r2
		dev-libs/libgusb[introspection]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.94.1-test-timeout.patch"
)

# As this version introduces metainfo for appstreamcli checking,
# we neeed to disable network access during the tests.
export AS_VALIDATE_NONET="true"

src_unpack() {
	default
	if use tod; then
		mv "${WORKDIR}/${MY_P}+tod1" "${S}" || die
	fi
}

src_configure() {
	# TODO: wire up test deps (cairo, pygobject, etc) for extra tests
	# currently skipped.
	local emesonargs=(
		$(meson_use examples gtk-examples)
		$(meson_use gtk-doc doc)
		$(meson_use introspection introspection)
		-Ddrivers=all
		-Dinstalled-tests=false
		-Dudev_rules=enabled
		-Dudev_rules_dir=$(get_udevdir)/rules.d
	)

	use tod && emesonargs+=( -Dtod=true )

	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
