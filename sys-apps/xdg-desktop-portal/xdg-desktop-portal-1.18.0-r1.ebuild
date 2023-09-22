# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-any-r1 systemd

DESCRIPTION="Desktop integration portal"
HOMEPAGE="https://flatpak.org/ https://github.com/flatpak/xdg-desktop-portal"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="geolocation flatpak seccomp systemd test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.66:2
	dev-libs/json-glib
	dev-python/docutils
	>=media-video/pipewire-0.3:=
	>=sys-fs/fuse-3.10.0:3[suid]
	x11-libs/gdk-pixbuf
	geolocation? ( >=app-misc/geoclue-2.5.3:2.0 )
	flatpak? ( sys-apps/flatpak )
	seccomp? ( sys-apps/bubblewrap )
	systemd? ( sys-apps/systemd )
	test? ( dev-libs/libportal )
"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
"
BDEPEND="
	dev-util/gdbus-codegen
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	# These tests require connections to pipewire, internet, /dev/fuse
	"${FILESDIR}/${P}-sandbox-disable-failing-tests.patch"

	# https://github.com/flatpak/xdg-desktop-portal/pull/1100
	"${FILESDIR}/0001-meson.build-allow-linux-to-build-without-flatpak-ins.patch"
	"${FILESDIR}/0002-meson.build-allow-linux-to-build-without-bubblewrap.patch"
	"${FILESDIR}/0003-Make-flatpak-bwrap-optional.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

python_check_deps() {
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

src_configure() {
	local emesonargs=(
		-Ddbus-service-dir="${EPREFIX}/usr/share/dbus-1/services"
		-Dflatpak-interfaces-dir="${EPREFIX}/usr/share/dbus-1/interfaces"
		-Dsystemd-user-unit-dir="$(systemd_get_userunitdir)"
		$(meson_feature flatpak)
		# Only used for tests
		$(meson_feature test libportal)
		$(meson_feature geolocation geoclue)
		$(meson_feature seccomp bwrap)
		$(meson_feature systemd)
		# Requires flatpak
		-Ddocbook-docs=disabled
		# -Dxmlto-flags=
		-Ddatarootdir="${EPREFIX}/usr/share"
		-Dman-pages=enabled
		-Dinstalled-tests=false
		$(meson_feature test pytest)
	)

	meson_src_configure
}

pkg_postinst() {
	if ! has_version gui-libs/xdg-desktop-portal-lxqt && ! has_version gui-libs/xdg-desktop-portal-wlr && \
		! has_version kde-plasma/xdg-desktop-portal-kde && ! has_version sys-apps/xdg-desktop-portal-gnome && \
		! has_version sys-apps/xdg-desktop-portal-gtk; then
		elog "${PN} is not usable without any of the following XDP"
		elog "implementations installed:"
		elog "  gui-libs/xdg-desktop-portal-lxqt"
		elog "  gui-libs/xdg-desktop-portal-wlr"
		elog "  kde-plasma/xdg-desktop-portal-kde"
		elog "  sys-apps/xdg-desktop-portal-gnome"
		elog "  sys-apps/xdg-desktop-portal-gtk"
	fi
}
