# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="the GNU network swiss army knife"
HOMEPAGE="http://netcat.sourceforge.net/"
SRC_URI="mirror://sourceforge/netcat/netcat-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ppc sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="debug nls"

S=${WORKDIR}/netcat-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-flagcount.patch \
		"${FILESDIR}"/${PN}-close.patch \
		"${FILESDIR}"/${PN}-LC_CTYPE.patch
}

src_configure() {
	use debug && append-flags -DDEBUG
	econf $(use_enable nls)
}

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_install() {
	default
	rm "${ED}"usr/bin/nc
}
