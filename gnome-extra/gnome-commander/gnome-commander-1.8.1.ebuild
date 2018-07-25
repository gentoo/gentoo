# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="https://gcmd.github.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="chm exif gsf pdf taglib samba test +unique"

RDEPEND="
	app-text/yelp-tools
	>=dev-libs/glib-2.44.0:2
	unique? ( >=dev-libs/libunique-0.9.3:1 )
	gnome-base/gnome-keyring
	>=gnome-base/gnome-vfs-2.0.0
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.4.0
	>=x11-libs/gtk+-2.18.0:2
	chm? ( dev-libs/chmlib )
	exif? ( >=media-gfx/exiv2-0.14 )
	gsf? ( >=gnome-extra/libgsf-1.12.0 )
	samba? ( >=gnome-base/gnome-vfs-2.0.0[samba] )
	pdf? ( >=app-text/poppler-0.18 )
	taglib? ( >=media-libs/taglib-1.4 )
"
DEPEND="
	${RDEPEND}
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.7.0 )
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_with chm libchm) \
		$(use_with exif exiv2) \
		$(use_with gsf libgsf) \
		$(use_with pdf poppler) \
		$(use_with samba) \
		$(use_with taglib) \
		$(use_with unique)
}

pkg_postinst() {
	gnome2_pkg_postinst
	has_version dev-util/meld || elog "You need dev-util/meld to synchronize files and directories."
	has_version gnome-extra/yelp || elog "You need gnome-extra/yelp to view the docs."
}
