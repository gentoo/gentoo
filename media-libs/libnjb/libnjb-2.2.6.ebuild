# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit libtool multilib udev

DESCRIPTION="a C library and API for communicating with the Creative Nomad JukeBox digital audio player"
HOMEPAGE="http://libnjb.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e 's:SUBDIRS = src sample doc:SUBDIRS = src doc:' \
		Makefile.in || die

	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog* FAQ HACKING README

	udev_newrules "${FILESDIR}"/${PN}.rules 80-${PN}.rules

	find "${D}" -name '*.la' -exec rm -f {} +
}
