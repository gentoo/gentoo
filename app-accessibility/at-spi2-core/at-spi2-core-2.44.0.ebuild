# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson-multilib systemd virtualx xdg

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility https://gitlab.gnome.org/GNOME/at-spi2-core"

LICENSE="LGPL-2.1+"
SLOT="2"
IUSE="X gtk-doc +introspection"
REQUIRED_USE="gtk-doc? ( X )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.62:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54.0:= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	"${FILESDIR}/${PN}-2.0.2-disable-teamspaces-test.patch"
	"${FILESDIR}/${PV}-Fix-build-with-X11-disabled.patch"
)

multilib_src_configure() {
	local emesonargs=(
		-Dsystemd_user_dir="$(systemd_get_userunitdir)"
		$(meson_native_use_bool gtk-doc docs)
		-Dintrospection=$(multilib_native_usex introspection)
		-Dx11=$(usex X)
	)
	meson_src_configure
}

multilib_src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}"
}
