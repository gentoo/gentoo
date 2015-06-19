# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipv6calc/ipv6calc-0.93.1.ebuild,v 1.7 2013/07/16 19:13:05 pinkbyte Exp $

EAPI="4"
inherit fixheadtails

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="http://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc sparc x86"
IUSE="geoip test"

RDEPEND="geoip? ( >=dev-libs/geoip-1.4.7 )"
DEPEND="${RDEPEND}
	test? ( dev-perl/Digest-SHA1 )"

src_prepare() {
	# Tests don't work, will be fixed next release
	echo true > ipv6calc/test_showinfo.sh || die
	ht_fix_file configure
}

src_configure() {
	econf $(use_enable geoip)
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
