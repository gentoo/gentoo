# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/scw/scw-0.4.7.ebuild,v 1.6 2014/08/10 20:06:45 slyfox Exp $

EAPI=3

DESCRIPTION="A GTK+ widget set specifically designed for chat programs"
HOMEPAGE="http://scwwidgets.googlepages.com"
SRC_URI="http://scwwidgets.googlepages.com/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable doc gtk-doc)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
