# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A tool to monitor the traffic load on network-links"
HOMEPAGE="http://oss.oetiker.ch/mrtg/"
SRC_URI="http://oss.oetiker.ch/mrtg/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86"
IUSE="selinux"

DEPEND="
	>=dev-perl/SNMP_Session-1.13-r2
	>=dev-perl/Socket6-0.23
	dev-lang/perl
	media-libs/gd[png]
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-mrtg )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-socket6.patch
	rm ./lib/mrtg2/{SNMP_{Session,util},BER}.pm || die
}

src_install () {
	keepdir /var/lib/mrtg

	default

	mv "${ED}"/usr/share/doc/{mrtg2,${PF}} || die

	newinitd "${FILESDIR}/mrtg.rc" ${PN}
	newconfd "${FILESDIR}/mrtg.confd" ${PN}
}
