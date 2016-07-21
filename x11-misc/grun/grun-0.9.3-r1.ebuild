# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A GTK based Run dialog resembling the Windows Run dialog, just like xexec"
HOMEPAGE="https://github.com/lrgc/grun"
SRC_URI="https://grun.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no_nls.patch
}

src_configure() {
	[[ -z ${TERM} ]] && TERM=xterm

	econf \
		$(use_enable nls) \
		--disable-gtktest \
		--enable-associations \
		--enable-testfile \
		--with-default-xterm=${TERM}
}

src_install() {
	default
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
