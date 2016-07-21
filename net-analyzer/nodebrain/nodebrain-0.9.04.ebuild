# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Monitor and do event correlation"
HOMEPAGE="http://nodebrain.sourceforge.net/"
SRC_URI="mirror://sourceforge/nodebrain/nodebrain-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

CDEPEND="dev-libs/libedit"
DEPEND="
	${CDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	sys-apps/texinfo
"
RDEPEND="
	${CDEPEND}
	!sys-boot/netboot
	!www-apps/nanoblogger
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8.14-include.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--include=/usr/include
}

src_install() {
	default
	use static-libs || prune_libtool_files
	dodoc AUTHORS NEWS README THANKS sample/*
	dohtml html/*
}
