# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A mail handling library"
HOMEPAGE="http://libmail.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="apop debug gnutls profile sasl static-libs"

DEPEND="gnutls? ( >=net-libs/gnutls-2 )
	sasl? ( >=dev-libs/cyrus-sasl-2 )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

# Do not unset user's CFLAGS, bug #454558
PATCHES=( "${FILESDIR}/${P}-respect-cflags.patch" )

src_prepare() {
	# Drop quotes from ACLOCAL_AMFLAGS otherwise aclocal will fail
	# see 447760
	sed -i -e "/ACLOCAL_AMFLAGS/s:\"::g" Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable apop)
		$(use_enable debug)
		$(use_enable gnutls tls)
		$(use_enable profile)
		$(use_enable sasl)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# headers, that are wrongly skipped from installing
	insinto /usr/include/libmail
	doins libmail/libmail_intl.h
	doins config.h
}
