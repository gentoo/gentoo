# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 optfeature

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="https://gcmd.github.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="exif gsf pdf samba taglib test +unique"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.70.0:2
	>=x11-libs/gtk+-2.24.0:2
	unique? ( >=dev-libs/libunique-0.9.3:1 )
	exif? ( >=media-gfx/exiv2-0.14 )
	taglib? ( >=media-libs/taglib-1.4 )
	gsf? ( >=gnome-extra/libgsf-1.12:= )
	pdf? ( >=app-text/poppler-0.18 )
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.7.0 )
"
BDEPEND="
	app-text/yelp-tools
	>=sys-devel/flex-2.0.0
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--without-libchm \
		$(use_with exif exiv2) \
		$(use_with gsf libgsf) \
		$(use_with pdf poppler) \
		$(use_with samba) \
		$(use_with taglib) \
		$(use_with unique)
}

pkg_postinst() {
	gnome2_pkg_postinst
	optfeature "synchronizing files and directories" dev-util/meld
	optfeature "viewing the documentation" gnome-extra/yelp
}
