# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit virtualx

DESCRIPTION="A number of classes and functions for programming GTK+ programs using C++"
HOMEPAGE="http://cxx-gtk-utils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/++/xx}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+gtk nls"

RDEPEND="
	dev-libs/glib:2
	gtk? ( x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		--disable-static \
		--without-guile \
		$(use_enable nls) \
		$(use_with gtk)
}

src_test() {
	virtx default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
