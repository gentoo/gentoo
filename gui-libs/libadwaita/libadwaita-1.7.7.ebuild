# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org meson python-any-r1 vala virtualx xdg

DESCRIPTION="Building blocks for modern GNOME applications"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/libadwaita/ https://gitlab.gnome.org/GNOME/libadwaita"

LICENSE="LGPL-2.1+"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="doc +introspection test +vala"
REQUIRED_USE="
	doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.80.0:2
	>=gui-libs/gtk-4.17.5:4[introspection?]
	dev-libs/appstream:=
	dev-libs/fribidi
	introspection? ( >=dev-libs/gobject-introspection-1.83.2:= )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
	doc? ( >=dev-util/gi-docgen-2021.1 )
	vala? ( $(vala_depend) )
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	dev-lang/sassc
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		-Dprofiling=false
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use doc documentation)
		$(meson_use test tests)
		-Dexamples=false
	)
	meson_src_configure
}

src_test() {
	addwrite /dev/dri
	virtx meson_src_test --timeout-multiplier 2
}

src_install() {
	meson_src_install
	if use doc; then
		mv "${ED}"/usr/share/doc/{${PN}-${SLOT},${PF}/html} || die
	fi
}
