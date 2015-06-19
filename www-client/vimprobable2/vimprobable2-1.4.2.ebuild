# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/vimprobable2/vimprobable2-1.4.2.ebuild,v 1.1 2014/01/23 00:52:34 radhermit Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A minimal web browser that behaves like the Vimperator plugin for Firefox"
HOMEPAGE="http://www.vimprobable.org/"
SRC_URI="mirror://sourceforge/vimprobable/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/libsoup:2.4
	net-libs/webkit-gtk:2
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1 vimprobablerc.5
}
