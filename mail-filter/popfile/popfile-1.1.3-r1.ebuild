# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Anti-spam bayesian filter"
HOMEPAGE="http://getpopfile.org"
SRC_URI="http://getpopfile.org/downloads/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk ipv6 libressl mysql ssl xmlrpc"

RDEPEND="virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	dev-perl/DBD-SQLite
	dev-perl/HTML-Tagset
	dev-perl/HTML-Template
	dev-perl/TimeDate
	dev-perl/DBI
	virtual/perl-Digest
	cjk? ( dev-perl/Encode-compat
		dev-perl/Text-Kakasi )
	mysql? ( dev-perl/DBD-mysql	)
	ipv6? ( dev-perl/IO-Socket-INET6 )
	ssl? ( !libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
		dev-perl/IO-Socket-SSL
		dev-perl/Net-SSLeay )
	xmlrpc? ( dev-perl/PlRPC )"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	local f
	for f in `find ./ -type f`; do
		edos2unix "${f}"
	done
}

src_install() {
	dodoc *.change*
	rm -rf *.change* license

	insinto /usr/share/${PN}
	doins -r *

	fperms 755 /usr/share/${PN}/{popfile,insert,pipe,bayes}.pl

	dosbin "${FILESDIR}"/${PN}
}
