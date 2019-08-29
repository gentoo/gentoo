# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="GTK-2 version of gnokii"
HOMEPAGE="http://www.gnokii.org/"
SRC_URI="http://www.gnokii.org/download/${PN}/${P}.tar.bz2"

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
