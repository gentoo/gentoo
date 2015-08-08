# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Trick Or Treat Daemon, a DNS proxy for 6to4"
HOMEPAGE="http://www.dillema.net/software/totd.html"
SRC_URI="http://www.dillema.net/software/${PN}/${P}.tar.gz"

LICENSE="totd BSD BSD-4"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-no_werror.patch
}

src_configure() {
	econf \
		--enable-ipv4 \
		--enable-ipv6 \
		--enable-stf \
		--enable-scoped-rewrite \
		--disable-http-server
}

src_install() {
	dosbin totd
	doman totd.8
	dodoc totd.conf.sample README INSTALL

	doinitd "${FILESDIR}"/totd
}

pkg_postinst() {
	elog "The totd.conf.sample file in /usr/share/doc/${P}/ contains"
	elog "a sample config file for totd. Make sure you create"
	elog "/etc/totd.conf with the necessary configurations"
}
