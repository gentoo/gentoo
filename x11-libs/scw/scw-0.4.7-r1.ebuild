# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A GTK+ widget set specifically designed for chat programs"
HOMEPAGE="http://scwwidgets.googlepages.com"
SRC_URI="http://scwwidgets.googlepages.com/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	doc? ( dev-util/gtk-doc )
	dev-util/glib-utils
	virtual/pkgconfig
"

src_configure() {
	econf $(use_enable doc gtk-doc)
}
