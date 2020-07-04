# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="https://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="https://github.com/pbiering/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="geoip libressl test"
RESTRICT="!test? ( test )"

RDEPEND="
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	geoip? ( >=dev-libs/geoip-1.4.7 )
"
DEPEND="${RDEPEND}
	test? ( dev-perl/Digest-SHA1 )
"

#dev-perl/URI is needed for web interface, that is not installed now

src_configure() {
	# These options are broken.  You can't disable them.  That's
	# okay because we want then force enabled.
	# --disable-db-as-registry
	# --disable-db-cc-registry
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
		--disable-dbip \
		--disable-dbip2 \
		--disable-external \
		--disable-ip2location \
		${myconf}
}

src_compile() {
	emake distclean
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
