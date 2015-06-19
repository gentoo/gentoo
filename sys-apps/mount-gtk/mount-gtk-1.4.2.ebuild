# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mount-gtk/mount-gtk-1.4.2.ebuild,v 1.2 2014/06/22 10:13:14 ssuominen Exp $

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="GTK+ based UDisks2 frontend"
HOMEPAGE="http://mount-gtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.28
	sys-fs/udisks:2
	x11-libs/c++-gtk-utils:0
	x11-libs/libX11
	x11-libs/libnotify:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS BUGS ChangeLog )

src_prepare() {
	epatch "${FILESDIR}"/${P}-c++11.patch
	sed -i -e 's:AC_CONFIG_HEADER:&S:' configure.ac || die
	eautoreconf
}

src_configure() {
	# acinclude.m4 is broken and environment flags override these:
	append-cxxflags -fexceptions -frtti -fsigned-char -fno-check-new -pthread
	econf --docdir=/usr/share/doc/${PF}
}
