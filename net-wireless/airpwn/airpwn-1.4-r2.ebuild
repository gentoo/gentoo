# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/airpwn/airpwn-1.4-r2.ebuild,v 1.3 2015/03/21 14:12:33 jlec Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic python-single-r1

DESCRIPTION="Tool for generic packet injection on 802.11"
HOMEPAGE="http://airpwn.sf.net"
SRC_URI="mirror://sourceforge/airpwn/$P.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-libs/libpcre
	dev-libs/openssl:0=
	net-libs/libnet:1.1=
	net-libs/libpcap
	net-wireless/lorcon-old"
RDEPEND="${DEPEND}"

src_configure() {
	econf
	sed -i "s/python2.4/${EPYTHON}/g" conf.h || die
	sed -i "s|-lorcon -lpthread -lpcre -lpcap -lnet|-lorcon -lpthread -lpcre -lpcap -lnet -lcrypto -l${EPYTHON}|g" Makefile  || die
}

src_install() {
	default

	if use examples; then
		insinto /usr/share/${PN}
		ecvs_clean
		sed -i "s#content/#/usr/share/${PN}/content/#" conf/* || die
		doins -r conf content
	fi
}
