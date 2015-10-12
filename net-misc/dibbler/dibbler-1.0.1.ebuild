# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils readme.gentoo systemd

DESCRIPTION="Portable DHCPv6 implementation (server, client and relay)"
HOMEPAGE="http://klub.com.pl/dhcpv6/"
SRC_URI="http://klub.com.pl/dhcpv6/dibbler/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~x86"
IUSE="doc"

DEPEND="doc? ( || (
		dev-texlive/texlive-latexextra
		dev-tex/floatflt )
	)"
RDEPEND=""

DOC_CONTENTS="Make sure that you modify client.conf, server.conf and/or relay.conf
to suit your needs. They are stored in /etc/dibbler"

src_prepare() {
	epatch_user
}

src_compile() {
	emake
	# devel documentation is broken and users should consult the online version
	# http://klub.com.pl/dhcpv6/doxygen/
	use doc && emake -C doc/ user
}

src_install() {
	readme.gentoo_create_doc

	dosbin dibbler-{client,relay,server}
	doman doc/man/*.8

	insinto /etc/dibbler
	doins doc/examples/*.conf
	dodir /var/lib/dibbler

	dodoc AUTHORS CHANGELOG RELNOTES TODO
	use doc && dodoc doc/dibbler-user.pdf

	doinitd "${FILESDIR}"/dibbler-{client,relay,server}
	systemd_dounit "${FILESDIR}"/dibbler-client.service
}
