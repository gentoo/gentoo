# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipv6calc/ipv6calc-0.97.4.ebuild,v 1.1 2014/08/03 23:34:19 blueness Exp $

EAPI="5"
inherit eutils

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="http://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="geoip test"

RDEPEND="
	dev-libs/openssl
	geoip? ( >=dev-libs/geoip-1.4.7 )
"
DEPEND="${RDEPEND}
	test? ( dev-perl/Digest-SHA1 )
"

#dev-perl/URI is needed for web interface, that is not installed now

src_configure() {
	if use geoip; then
		myconf=$(use_enable geoip)
		myconf+=" --with-geoip-db=${EPREFIX}/usr/share/GeoIP"
	fi
	econf \
		--disable-bundled-getopt \
		--disable-bundled-md5 \
		--enable-shared \
		--enable-dynamic-load \
		--enable-db-ieee \
		--enable-db-ipv4 \
		--enable-db-ipv6 \
		--disable-ip2location \
		${myconf}
}

src_compile() {
	# Disable default CFLAGS (-O2 and -g)
	emake DEFAULT_CFLAGS=""
}

src_test() {
	if [[ ${EUID} -eq 0 ]]; then
		# Disable tests that fail as root
		echo true > ipv6logstats/test_ipv6logstats.sh
	fi
	default
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog CREDITS README TODO USAGE
}
