# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic user

DESCRIPTION="ARIN rwhois daemon"
HOMEPAGE="http://projects.arin.net/rwhois/"
SRC_URI="http://projects.arin.net/rwhois/ftp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-devel/flex
	virtual/yacc
"

pkg_setup() {
	enewgroup rwhoisd
	enewuser rwhoisd -1 -1 /var/rwhoisd rwhoisd
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-destdir-${PV}.patch
	append-cflags -DNEW_STYLE_BIN_SORT
}

src_compile() {
	emake -C common
	emake -C regexp
	emake -C mkdb
	default
}

src_install () {
	default
	doinitd "${FILESDIR}"/rwhoisd
	newconfd "${FILESDIR}"/rwhoisd.conf rwhoisd
}

pkg_postinst () {
	einfo "Please make sure to set the userid in rwhoisd.conf to rwhoisd."
	einfo "It is highly inadvisable to run rwhoisd as root."
}
