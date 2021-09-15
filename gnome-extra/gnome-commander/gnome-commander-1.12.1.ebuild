# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME2_LA_PUNT="yes"

inherit gnome2 optfeature toolchain-funcs

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="https://gcmd.github.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="chm exif gsf pdf samba taglib test +unique"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/yelp-tools
	>=dev-libs/glib-2.62.0:2
	>=gnome-base/gnome-vfs-2.0.0
	>=x11-libs/gtk+-2.24.0:2
	chm? ( dev-libs/chmlib )
	exif? ( >=media-gfx/exiv2-0.14 )
	gsf? ( >=gnome-extra/libgsf-1.12.0 )
	pdf? ( >=app-text/poppler-0.18 )
	samba? ( >=gnome-base/gnome-vfs-2.0.0[samba] )
	taglib? ( >=media-libs/taglib-1.4 )
	unique? ( >=dev-libs/libunique-0.9.3:1 )
"
BDEPEND="
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.7.0 )
"

pkg_pretend() {
	if tc-is-gcc && [[ $(gcc-major-version) -lt 8 ]]; then
		eerror "Compilation with gcc older than version 8 is not supported"
		die "GCC too old, please use gcc-8 or above"
	fi
}

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
	optfeature "synchronizing files and directories" dev-util/meld
	optfeature "viewing the documentation" gnome-extra/yelp
}
