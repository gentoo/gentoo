# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="library to create GTK+ interfaces from GuiXml at runtime"
HOMEPAGE="http://www.crowdesigner.org"
SRC_URI="https://nothing-personal.googlecode.com/files/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

LANGS="ru"

RDEPEND="x11-libs/gtk+:3
	>=dev-libs/glib-2.28:2"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.18 )"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

src_configure() {
	econf \
		--disable-static \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/{authors.txt,news.{ru,en}.txt,readme.{ru,en}.txt}
	find "${ED}" -name '*.la' -exec rm -f {} +
}
