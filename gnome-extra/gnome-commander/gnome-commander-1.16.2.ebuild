# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson optfeature

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="https://gcmd.github.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc exif gsf pdf samba taglib test"
RESTRICT="!test? ( test )"

RDEPEND="
	doc? ( gnome-extra/yelp )
	>=dev-libs/glib-2.70.0:2
	>=x11-libs/gtk+-2.24.0:2
	exif? ( >=media-gfx/exiv2-0.14:= )
	gsf? ( >=gnome-extra/libgsf-1.12:= )
	pdf? ( >=app-text/poppler-0.18:=[cairo] )
	samba? ( gnome-base/gvfs[samba] )
	taglib? ( >=media-libs/taglib-1.4 )
"
BDEPEND="
	doc? ( app-text/yelp-tools )
	dev-util/glib-utils
	dev-build/gtk-doc-am
	app-alternatives/lex
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.7.0 )
"

src_configure() {
	local emesonargs=(
		$(meson_feature exif exiv2)
		$(meson_feature gsf libgsf)
		$(meson_feature pdf poppler)
		$(meson_feature samba)
		$(meson_feature taglib)
		$(meson_feature test tests)
		$(meson_use doc help)
		-Dunique=disabled
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst
	optfeature "synchronizing files and directories" dev-util/meld
}

pkg_postrm() {
	gnome2_schemas_update
}
