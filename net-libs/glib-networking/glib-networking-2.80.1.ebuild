# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson-multilib xdg

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/glib-networking"
LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="+gnome +libproxy +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.73.3:2[${MULTILIB_USEDEP}]
	libproxy? ( >=net-libs/libproxy-0.4.16[${MULTILIB_USEDEP}] )
	>=net-libs/gnutls-3.7.4:=[${MULTILIB_USEDEP}]
	ssl? ( app-misc/ca-certificates )
	gnome? ( gnome-base/gsettings-desktop-schemas )
"
DEPEND="${RDEPEND}
	test? ( net-libs/gnutls[pkcs11] )
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_prepare() {
	default
	xdg_environment_reset

	if ! use test ; then
		# Don't build tests unconditionally
		# This is a hack to avoid needing gnutls[pkcs11] when USE=-test
		# It may become a real runtime dependency in future
		# Please check!
		# bug #777462
		sed -i "/^subdir('tests')/d" tls/meson.build || die
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dgnutls=enabled
		-Dopenssl=disabled
		$(meson_feature !libproxy environment_proxy)
		$(meson_feature libproxy)
		$(meson_feature gnome gnome_proxy)
		-Dinstalled_tests=false
		-Ddebug_logs=false
	)
	meson_src_configure
}

multilib_src_test() {
	# Pretend the network is available so we get real libproxy parsing
	# output rather than it giving up early in e.g. systemd-nspawn in some
	# cases.
	# https://github.com/libproxy/libproxy/issues/260 (bug #914382)
	local -x GIO_USE_NETWORK_MONITOR=base
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm

	multilib_pkg_postrm() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postrm
}
