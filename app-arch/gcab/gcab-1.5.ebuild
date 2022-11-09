# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala xdg

DESCRIPTION="Library and tool for working with Microsoft Cabinet (CAB) files"
HOMEPAGE="https://wiki.gnome.org/msitools https://gitlab.gnome.org/GNOME/gcab"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc ~x86"

IUSE="gtk-doc +introspection test vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.62.0:2
	sys-libs/zlib
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PV}-meson-git-version-is-optional.patch
)

src_prepare() {
	default
	xdg_environment_reset
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		$(meson_use introspection)
		-Dnls=true
		$(meson_use vala vapi)
		$(meson_use test tests)
		-Dinstalled_tests=false
	)
	meson_src_configure
}
