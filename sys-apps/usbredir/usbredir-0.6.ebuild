# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usbredir/usbredir-0.6.ebuild,v 1.15 2014/01/15 12:54:33 ago Exp $

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="A simple TCP daemon and set of libraries for the usbredir protocol (redirecting USB traffic)"
HOMEPAGE="http://spice-space.org/page/UsbRedir"
SRC_URI="http://spice-space.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="ChangeLog README* TODO *.txt"

src_configure() {
	# http://bugs.freedesktop.org/show_bug.cgi?id=54643
	append-cflags -Wno-error

	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	# noinst_PROGRAMS
	dobin usbredirtestclient/usbredirtestclient
}
