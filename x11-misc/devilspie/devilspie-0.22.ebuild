# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools

DESCRIPTION="A Window Matching utility similar to Sawfish's Matched Windows feature"
HOMEPAGE="http://www.burtonini.com/blog/computers/devilspie"
SRC_URI="http://www.burtonini.com/computing/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.10
	x11-libs/gtk+:2
	>=x11-libs/libwnck-2.10:1
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	gnome-base/gnome-common" # Required by eautoreconf

src_prepare() {
	sed -i -e "s:\(/usr/share/doc/devilspie\):\1-${PVR}:" devilspie.1 || die
	sed -i -e '/-DG.*_DISABLE_DEPRECATED/d' src/Makefile.am || die
	eautoreconf
	export LIBS="-lX11"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	keepdir /etc/devilspie
}
