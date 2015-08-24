# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DESCRIPTION="GObject-based XIM protocol library"
HOMEPAGE="https://tagoh.bitbucket.org/libgxim/"
SRC_URI="https://bitbucket.org/tagoh/libgxim/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/check-0.9.4
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32
	>=sys-apps/dbus-0.23
	>=x11-libs/gtk+-2.2:2"
DEPEND="${RDEPEND}
	dev-lang/ruby
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )"

src_configure() {
	econf $(use_enable static-libs static) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README || die
}
