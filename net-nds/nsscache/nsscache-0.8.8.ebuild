# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit eutils python distutils

DESCRIPTION="commandline tool to sync directory services to local cache"
HOMEPAGE="http://code.google.com/p/nsscache/"
SRC_URI="http://nsscache.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nssdb nsscache"

DEPEND="dev-python/python-ldap"
RDEPEND="${DEPEND}
		nssdb? ( sys-libs/nss-db )
		nsscache? ( sys-auth/libnss-cache )"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}"/${PN}-0.8.3-starttls.patch
}

src_install() {
	distutils_src_install
	insinto /etc
	doins "${FILESDIR}/nsscache.conf" # overwrite default with working config.
	doman nsscache.1 nsscache.conf.5
	dodoc THANKS nsscache.cron
	keepdir /var/lib/nsscache
}
