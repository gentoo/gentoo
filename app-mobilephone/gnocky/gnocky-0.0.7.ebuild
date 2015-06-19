# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/gnocky/gnocky-0.0.7.ebuild,v 1.1 2014/09/15 09:20:01 jer Exp $

EAPI=5

DESCRIPTION="GTK-2 version of gnokii"
HOMEPAGE="http://www.gnokii.org/"
SRC_URI="${HOMEPAGE}download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-mobilephone/gnokii
	dev-libs/glib:2
	gnome-base/libglade:2.0
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
