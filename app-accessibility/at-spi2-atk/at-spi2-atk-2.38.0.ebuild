# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson multilib-minimal virtualx xdg

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.36.0[${MULTILIB_USEDEP}]
	>=app-accessibility/at-spi2-core-2.33.2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( >=dev-libs/libxml2-2.9.1 )
"

multilib_src_configure() {
	local emesonargs=(
		$(meson_use test tests)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}"
}

multilib_src_install() {
	meson_src_install
}
