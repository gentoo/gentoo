# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs user

DESCRIPTION="a DNS daemon which is designed to serve DNSBL zones"
HOMEPAGE="http://www.corpit.ru/mjt/rbldnsd.html"
SRC_URI="http://www.corpit.ru/mjt/rbldnsd/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~sparc x86 ~x86-fbsd"
IUSE="ipv6 zlib"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-asneeded.patch
}

src_compile() {
	# econf doesn't work
	./configure \
		$(use_enable ipv6) \
		$(use_enable zlib) || die "./configure failed"

	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		|| die "emake failed"
}

src_install() {
	dosbin rbldnsd || die "dosbin failed"
	doman rbldnsd.8
	keepdir /var/db/rbldnsd
	dodoc CHANGES* TODO NEWS README* "${FILESDIR}"/example
	newinitd "${FILESDIR}"/initd rbldnsd
	newconfd "${FILESDIR}"/confd rbldnsd
}

pkg_postinst() {
	enewgroup rbldns
	enewuser rbldns -1 -1 /var/db/rbldnsd rbldns
	chown rbldns:rbldns /var/db/rbldnsd

	elog "for testing purpose, example zone file has been installed"
	elog "Look in /usr/share/doc/${PF}/"
}
