# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 python-single-r1

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="http://gcmd.github.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chm exif gsf pdf python taglib"

RDEPEND="
	app-text/gnome-doc-utils
	>=dev-libs/glib-2.6.0:2
	>=dev-libs/libunique-0.9.3:1
	gnome-base/gnome-keyring
	>=gnome-base/gnome-vfs-2.0.0
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.4.0
	>=x11-libs/gtk+-2.8.0:2
	chm? ( dev-libs/chmlib )
	exif? ( >=media-gfx/exiv2-0.14 )
	gsf? ( >=gnome-extra/libgsf-1.12.0 )
	pdf? ( >=app-text/poppler-0.18 )
	python? ( >=dev-python/gnome-vfs-python-2.0.0 )
	taglib? ( >=media-libs/taglib-1.4 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

src_configure() {
	DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"
	gnome2_src_configure \
		--disable-static \
		$(use_enable python) \
		$(use_with chm libchm) \
		$(use_with exif exiv2) \
		$(use_with gsf libgsf) \
		$(use_with taglib) \
		$(use_with pdf poppler)
}

pkg_postinst() {
	gnome2_pkg_postinst
	has_version dev-util/meld || elog "You need dev-util/meld to synchronize files and directories."
	has_version gnome-extra/yelp || elog "You need gnome-extra/yelp to view the docs."
}
