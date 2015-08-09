# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

MY_P=${PN}-3.0-${PV}

DESCRIPTION="A library for registering global keyboard shortcuts"
HOMEPAGE="http://kaizer.se/wiki/keybinder/"
SRC_URI="http://kaizer.se/publicfiles/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 x86"
IUSE="+introspection"

RDEPEND="x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS NEWS README"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable introspection) \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	default
	prune_libtool_files --all
	dosym /usr/share/doc/${PF}/html/${PN}-3.0 /usr/share/gtk-doc/html/${PN}-3.0
}
