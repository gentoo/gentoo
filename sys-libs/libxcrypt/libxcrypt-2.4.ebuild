# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libxcrypt/libxcrypt-2.4.ebuild,v 1.3 2013/11/25 20:48:27 pacho Exp $

EAPI=5
inherit eutils multilib

DESCRIPTION="A replacement for libcrypt with DES, MD5 and blowfish support"
SRC_URI="mirror://debian/pool/main/libx/${PN}/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://packages.debian.org/sid/libxcrypt1"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4-glibc-2.16.patch"
}

src_configure() {
	# Do not install into /usr so that tcb and pam can use us.
	econf --libdir=/$(get_libdir) --disable-static
}

src_install() {
	default
	prune_libtool_files
}
