# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="GTK+ GUI building tool"
HOMEPAGE="http://www.crowdesigner.org"
SRC_URI="http://nothing-personal.googlecode.com/files/crow-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

LANGS="ru"

RDEPEND=">=dev-libs/guiloader-2.21
	>=dev-libs/guiloader-c++-2.21
	dev-cpp/gtkmm:2.4
	>=dev-libs/dbus-glib-0.86"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.18 )"

S=${WORKDIR}/crow-${PV}

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc doc/{authors.txt,news.{en,ru}.txt,readme.{en,ru}.txt,readme.ru.txt} || die
}
