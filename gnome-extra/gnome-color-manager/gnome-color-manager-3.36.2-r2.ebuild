# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson virtualx xdg

DESCRIPTION="GNOME color profile tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-color-manager/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
RDEPEND="
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.4:3[X]
	>=x11-misc/colord-1.3.1:0=
	>=media-libs/lcms-2.2:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	# Help consists of 3 sentences but installs 108 files
	truncate -s0 help/meson.build || die
	# Building man pages requires docbook2man
	truncate -s0 man/meson.build || die
}

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	local emesonargs=(
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
