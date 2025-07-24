# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="https://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="https://github.com/pbiering/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cgi geoip +openssl"

RDEPEND="
	cgi? (
		dev-perl/HTML-Parser
		dev-perl/URI
		www-servers/apache
	)
	geoip? (
		dev-libs/geoip
		dev-libs/libmaxminddb:=
	)
	openssl? ( >=dev-libs/openssl-3.0.0:= )
	!openssl? ( app-crypt/libmd )
"
DEPEND="${RDEPEND}"

PATCHES=(
	# https://github.com/pbiering/ipv6calc/pull/49
	"${FILESDIR}"/${P}-fix_directcall_ar.patch
	"${FILESDIR}"/${P}-ldconfig_musl.patch
)

DOCS=( ChangeLog CREDITS README README.MaxMindDB README.GeoIP2 TODO USAGE )
HTML_DOCS=( doc/ipv6calc.html )

src_configure() {
	# something is broken with clang. to investigate.
	# see https://github.com/pbiering/ipv6calc/issues/45
	tc-is-clang && append-ldflags $(no-as-needed) && filter-lto

	# These options are broken.  You can't disable them.  That's
	# okay because we want then force enabled.
	# > libipv6calc_db_wrapper_BuiltIn.c:244:91:
	# > error: ‘dbipv4addr_registry_status’ undeclared (first use in this function)
	# --disable-db-as-registry
	# --disable-db-cc-registry

	tc-export AR
	local myeconfargs=(
		--disable-compiler-warning-to-error
		--disable-bundled-getopt
		--disable-bundled-md5
		--enable-shared
		--enable-dynamic-load
		--enable-db-ieee
		--enable-db-ipv4
		--enable-db-ipv6
		--disable-dbip
		--disable-dbip2
		--disable-external
		--disable-ip2location
		# disable legacy md5
		# use libmd or openssl-evp-md5 (by default)
		--disable-openssl-md5
		$(use_enable openssl openssl-evp-md5)
		$(use_enable !openssl libmd-md5)
		$(use_enable cgi mod_ipv6calc)
		$(use_enable geoip)
		$(use_enable geoip mmdb)
	)

	if use geoip; then
		myeconfargs+=( "--with-geoip-db=${EPREFIX}/usr/share/GeoIP" )
	fi

	econf "${myeconfargs[@]}"
}

src_test() {
	if [[ ${EUID} -eq 0 ]]; then
		# Disable tests that fail as root
		echo true > ipv6logstats/test_ipv6logstats.sh
	fi
	# it requires an apache instance
	echo true > mod_ipv6calc/test_mod_ipv6calc.sh
	# it requires network
	echo true > ipv6calcweb/test_ipv6calcweb.sh
	echo true > ipv6calcweb/test_ipv6calcweb_form.sh
	default
}
