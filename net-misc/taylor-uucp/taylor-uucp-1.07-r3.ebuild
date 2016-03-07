# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic autotools

DESCRIPTION="Taylor UUCP"
HOMEPAGE="http://www.airs.com/ian/uucp.html"
SRC_URI="mirror://gnu/uucp/uucp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

S="${WORKDIR}/uucp-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-fprintf.patch
	mv configure.{in,ac} || die
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	eautoreconf
}

src_configure() {
	append-cppflags -D_GNU_SOURCE -fno-strict-aliasing
	econf --with-newconfigdir=/etc/uucp
}

src_install() {
	dodir /usr/share/man/man{1,8}
	dodir /usr/share/info
	dodir /etc/uucp
	dodir /usr/bin /usr/sbin
	diropts -o uucp -g uucp -m 0750
	keepdir /var/log/uucp /var/spool/uucp
	diropts -o uucp -g uucp -m 0775
	keepdir /var/spool/uucppublic

	emake \
		"prefix=${D}/usr" \
		"sbindir=${D}/usr/sbin" \
		"bindir=${D}/usr/bin" \
		"man1dir=${D}/usr/share/man/man1" \
		"man8dir=${D}/usr/share/man/man8" \
		"newconfigdir=${D}/etc/uucp" \
		"infodir=${D}/usr/share/info" \
		install install-info
	sed -i -e 's:/usr/spool:/var/spool:g' sample/config
	cp sample/* "${ED}/etc/uucp" || die
	dodoc ChangeLog NEWS README TODO
}

pkg_preinst() {
	usermod -s /bin/bash uucp
}
