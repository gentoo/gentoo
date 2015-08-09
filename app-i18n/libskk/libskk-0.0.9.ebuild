# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

VALA_MIN_API_VERSION=0.12

inherit vala

DESCRIPTION="GObject-based library to deal with Japanese kana-to-kanji conversion method"
HOMEPAGE="https://github.com/ueno/libskk"
SRC_URI="mirror://github/ueno/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls static-libs"

RDEPEND="dev-libs/glib
	dev-libs/libgee:0
	dev-libs/json-glib
	>=dev-libs/gobject-introspection-0.9
	$(vala_depend)
	nls? ( virtual/libintl )"
#	>=dev-util/valadoc-0.3.1
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete
	fi

	doman docs/skk.1
	dodoc AUTHORS ChangeLog NEWS README
}
