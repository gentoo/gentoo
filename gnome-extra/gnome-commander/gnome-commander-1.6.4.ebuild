# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 python-single-r1

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="http://gcmd.github.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chm exif gsf pdf python taglib samba test +unique"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	app-text/gnome-doc-utils
	>=dev-libs/glib-2.44.0:2
	unique? ( >=dev-libs/libunique-0.9.3:1 )
	gnome-base/gnome-keyring
	>=gnome-base/gnome-vfs-2.0.0
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.4.0
	>=x11-libs/gtk+-2.8.0:2
	chm? ( dev-libs/chmlib )
	exif? ( >=media-gfx/exiv2-0.14 )
	gsf? ( >=gnome-extra/libgsf-1.12.0 )
	samba? ( >=gnome-base/gnome-vfs-2.0.0[samba] )
	pdf? ( >=app-text/poppler-0.18 )
	python? (
			${PYTHON_DEPS}
			>=dev-python/gnome-vfs-python-2.0.0
	)
	taglib? ( >=media-libs/taglib-1.4 )
"
DEPEND="
	${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.7.0 )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable python) \
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
