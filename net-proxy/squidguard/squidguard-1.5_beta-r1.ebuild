# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WANT_AUTOMAKE=none

inherit eutils autotools user

MY_P="squidGuard-${PV/_/-}"

DESCRIPTION="Combined filter, redirector and access controller plugin for Squid"
HOMEPAGE="http://www.squidguard.org"
SRC_URI="http://www.squidguard.org/Downloads/Devel/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="ldap"

RDEPEND=">=sys-libs/db-2
	ldap? ( net-nds/openldap:0 )"

DEPEND="${RDEPEND}
	sys-devel/bison:0
	sys-devel/flex:0"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup squid
	enewuser squid -1 -1 /var/cache/squid squid
}

src_prepare() {
	mv configure.in configure.ac || die
	epatch \
		"${FILESDIR}/${P}-gentoo.patch" \
		"${FILESDIR}/${P}-protocol.patch"

	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ldap) \
		--with-sg-config=/etc/squidGuard/squidGuard.conf \
		--with-sg-logdir=/var/log/squidGuard
}

src_install() {
	emake prefix="/usr" INSTDIR="${D}" install

	keepdir /var/log/squidGuard
	fowners squid:squid /var/log/squidGuard

	insinto /etc/squidGuard/sample
	doins "${FILESDIR}"/squidGuard.conf.*
	insinto /etc/squidGuard/sample/db
	doins "${FILESDIR}"/blockedsites

	dodoc ANNOUNCE CHANGELOG README
	dohtml doc/*.html
	docinto text
	dodoc doc/*.txt
}

pkg_postinst() {
	einfo "To enable squidGuard, add the following lines to /etc/squid/squid.conf:"
	einfo "    url_rewrite_program /usr/bin/squidGuard"
	einfo "    url_rewrite_children 10"
	einfo ""
	einfo "Remember to edit /etc/squidGuard/squidGuard.conf first!"
	einfo "Examples can be found in /etc/squidGuard/sample/"
}
