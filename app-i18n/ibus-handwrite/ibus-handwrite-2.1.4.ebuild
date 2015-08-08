# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils python autotools-utils multilib

DESCRIPTION="hand write recognition/input using ibus IM engine"
HOMEPAGE="http://code.google.com/p/ibus-handwrite/"
SRC_URI="http://ibus-handwrite.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls +zinnia"

RDEPEND="zinnia? ( app-i18n/zinnia app-i18n/zinnia-tomoe )
	>=app-i18n/ibus-1.3.0
	>=x11-libs/gtk+-2.10
	x11-libs/gtkglext"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable zinnia)
		$(use_with zinnia zinnia-tomoe "${EPREFIX}"/usr/$(get_libdir)/zinnia/model/tomoe)
	)
	autotools-utils_src_configure
}
