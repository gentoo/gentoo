# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 vala virtualx

DESCRIPTION="Spell check library for GTK+ applications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gspell"

LICENSE="LGPL-2.1+"
SLOT="0/2" # subslot = libgspell-1 soname version
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="+introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=app-text/enchant-2.1.3:2
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.20:3[introspection?]
	dev-libs/icu:=
	introspection? ( >=dev-libs/gobject-introspection-1.42.0:= )
"
DEPEND="${RDEPEND}
	test? ( sys-apps/dbus )
"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.25
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	test? (
		app-text/enchant:2[hunspell]
		|| (
			app-dicts/myspell-en[l10n_en(+)]
			app-dicts/myspell-en[l10n_en-US(+)]
		)
	)
"
# Tests require a en_US dictionary and fail with deprecated enchant aspell backend:
# So enchant[hunspell] + myspell-en ensure they pass (hunspell is ordered before aspell),
# however a different backend like hspell or nuspell + their en_US dict might be fine too,
# but we don't support them at this time (2020-04-12) in enchant:2

src_prepare() {
	use vala && vala_setup
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_test() {
	virtx dbus-run-session emake check
}
