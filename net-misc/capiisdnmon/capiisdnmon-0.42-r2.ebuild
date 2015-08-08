# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="a CAPI 2.0 ISDN call monitor with LDAP name resolution"
HOMEPAGE="http://capiisdnmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/capiisdnmon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="net-dialup/capi4k-utils
	net-nds/openldap
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/xosd
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-gcc44.patch" \
		"${FILESDIR}/${P}-capiv3.patch"

	append-cppflags -DLDAP_DEPRECATED

	sed -i -e 's/capiIsdnMon:://' capiisdnmon.h || die

	# Fix linking, bugs #370101 and #540672
	append-libs -lX11 -llber
	append-ldflags -pthread

	epatch_user
}

src_install() {
	default

	newicon icon1.xpm capiisdnmon.xpm
	make_desktop_entry capiIsdnMon "CAPI ISDN Monitor" capiisdnmon
}
