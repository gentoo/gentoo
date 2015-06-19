# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-quartz/gtk-engines-quartz-0.2.ebuild,v 1.2 2012/05/05 04:10:05 jdhore Exp $

EAPI=3

inherit autotools

MY_NAME=gtk-quartz-engine-${PV}

DESCRIPTION="OSX GTK+ Theme Engine"
HOMEPAGE="http://sourceforge.net/apps/trac/gtk-osx/wiki/GtkQuartzEngine"
SRC_URI="http://downloads.sourceforge.net/project/gtk-osx/GTK%20Quartz%20Engine/${MY_NAME}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_NAME}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
