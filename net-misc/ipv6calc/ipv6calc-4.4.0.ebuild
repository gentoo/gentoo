# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools flag-o-matic eapi9-ver optfeature toolchain-funcs

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="https://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="https://github.com/pbiering/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE="apache geoip +openssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	apache? ( www-servers/apache )
	geoip? (
		dev-libs/geoip
		dev-libs/libmaxminddb:=
	)
	openssl? ( >=dev-libs/openssl-3.0.0:= )
	!openssl? ( app-crypt/libmd )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-perl/HTML-Parser
		dev-perl/URI
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.2-ldconfig_musl.patch
	"${FILESDIR}"/${PN}-4.3.2-fix_configure.patch
)

DOCS=( ChangeLog CREDITS README README.MaxMindDB README.GeoIP2 TODO USAGE )
HTML_DOCS=( doc/ipv6calc.html )

src_prepare() {
	default
	# configure.ac is patched
	eautoconf
}

src_configure() {
	# see https://github.com/pbiering/ipv6calc/issues/45
	use apache && tc-is-clang && filter-lto
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
		$(use_enable apache mod_ipv6calc)
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
		echo true > ipv6logstats/test_ipv6logstats.sh || die
	fi
	# it requires an apache instance
	echo true > mod_ipv6calc/test_mod_ipv6calc.sh || die
	# it requires network
	echo true > ipv6calcweb/test_ipv6calcweb.sh || die
	echo true > ipv6calcweb/test_ipv6calcweb_form.sh || die
	default
}

src_install() {
	insinto /usr/share/ipv6calc/db/lisp
	doins databases/registries/lisp/site-db{,.txt}
	insinto /usr/share/ipv6calc/ipv6calcweb
	doins ipv6calcweb/ipv6calcweb.{cgi,conf} ipv6calcweb/{USAGE,README}
	insinto /usr/share/ipv6calc/ipv6loganon
	doins ipv6loganon/README
	insinto /usr/share/ipv6calc/ipv6logconv
	doins examples/analog/*
	insinto /usr/share/ipv6calc/ipv6logstats
	doins ipv6logstats/{example_*,collect_ipv6logstats.pl,README}

	if use apache; then
		insinto /usr/share/ipv6calc/mod_ipv6calc
		doins mod_ipv6calc/{ipv6calc.cgi,README.md}
	fi

	default
}

pkg_postinst() {
	optfeature "the cgi-script ipv6calcweb.cgi" "dev-perl/HTML-Parser dev-perl/URI"
	if ver_replacing -lt 4.4.0; then
		ewarn "To avoid confusion with ipv6calcweb (cgi script) now installed by default,"
		ewarn "the useflag cgi is replaced by apache."
	fi
}
