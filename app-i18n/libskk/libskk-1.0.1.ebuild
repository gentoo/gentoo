# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit ltprune vala virtualx

DESCRIPTION="GObject-based library to deal with Japanese kana-to-kanji conversion method"
HOMEPAGE="https://github.com/ueno/libskk"
SRC_URI="https://bitbucket.org/${PN}/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+introspection nls static-libs"

RDEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0
	introspection? ( dev-libs/gobject-introspection )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
	econf \
		$(use_enable introspection) \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_test() {
	export GSETTINGS_BACKEND="memory"
	virtx emake check
}

src_install() {
	default
	prune_libtool_files
}
