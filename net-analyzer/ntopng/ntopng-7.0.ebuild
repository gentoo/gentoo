# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools toolchain-funcs

# Check this on bumps, get latest commit from the relevant branch (e.g. 7.0-stable)
# See bug #894152 and https://github.com/ntop/ntopng/issues/7203
NTOPNG_DIST_COMMIT="c7bb4b80afae70a17a016409dc07c269be05d4af"
DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/ntopng/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/ntop/ntopng-dist/archive/${NTOPNG_DIST_COMMIT}.tar.gz -> ${P}-web-${NTOPNG_DIST_COMMIT}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="snmp"

DEPEND="dev-db/sqlite:3
	dev-libs/expat
	dev-libs/hiredis:=
	dev-libs/json-c:=
	dev-libs/libmaxminddb
	dev-libs/libsodium:=
	dev-libs/openssl:=
	snmp? ( net-analyzer/net-snmp:= )
	net-analyzer/rrdtool
	net-libs/libpcap
	~net-libs/nDPI-6.0:=
	>=net-libs/zeromq-3:=
	net-misc/curl
	sys-libs/libcap
	virtual/zlib:="
RDEPEND="${DEPEND}
	acct-user/ntopng
	acct-group/ntopng
	dev-db/redis"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Follows upstream's autogen.sh
	sed \
		-e "s/@VERSION@/${PV}.$(date +%y%m%d)/g" \
		-e "s/@SHORT_VERSION@/${PV}/g" \
		-e "s/@GIT_DATE@/$(date)/g" \
		-e "s/@GIT_RELEASE@/${PV}.$(date +%y%m%d)/g" \
		-e "s/@GIT_BRANCH@//g" < "${S}/configure.ac.in" \
		> "${S}/configure.ac" || die

	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG

	# Avoid automagic dependencies
	local -x ac_cv_lib_ldap_ldap_initialize=no
	local -x ac_cv_lib_nl_nl_handle_alloc=no
	local -x ac_cv_lib_radcli_rc_read_config=no
	local -x ac_cv_lib_rdkafka_rd_kafka_metadata=no
	if ! use snmp; then
		local -x ac_cv_lib_netsnmp_init_snmp=no
		local -x ac_cv_lib_snmp_init_snmp=no
	fi

	# configure.ac.in at least has some bashisms(?) which get lost(?)
	# in conversion to configure.ac (like [ -> nothing?) so just force
	# bash for now. It's still not quite right but at least upstream will be
	# testing with it. TODO: fix this!
	CONFIG_SHELL="${BROOT}/bin/bash" econf \
		--with-dynamic-ndpi \
		--with-ndpi-includes="${ESYSROOT}"/usr/include/ndpi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		MYCFLAGS="${CFLAGS}" \
		MYLDFLAGS="${LDFLAGS}"
}

src_install() {
	# httpdocs/geoip/README.geolocation.md is a symlink, change to real file
	GEOLOCATION_MD="httpdocs/geoip/README.geolocation.md"
	if [[ -h "${GEOLOCATION_MD}" ]] ; then
		GEOLOCATION_MD_REAL=$(readlink -m -- "${GEOLOCATION_MD}" || die)
		ln -f ${GEOLOCATION_MD_REAL} ${GEOLOCATION_MD} || die
	fi

	SHARE_NTOPNG_DIR="${EPREFIX}/usr/share/${PN}"
	insinto "${SHARE_NTOPNG_DIR}"
	doins -r httpdocs
	doins -r scripts

	insinto "${SHARE_NTOPNG_DIR}"/httpdocs/dist
	doins -r "${WORKDIR}"/ntopng-dist-${NTOPNG_DIST_COMMIT}/.

	insinto "${SHARE_NTOPNG_DIR}/third-party"
	doins -r third-party/i18n.lua-master
	doins -r third-party/lua-resty-template-master

	exeinto /usr/bin
	doexe "${PN}"
	doman "${PN}.8"

	newinitd "${FILESDIR}"/ntopng.init.d ntopng
	newconfd "${FILESDIR}"/ntopng.conf.d ntopng

	keepdir /var/lib/ntopng
	fowners ntopng /var/lib/ntopng
}

pkg_postinst() {
	elog "ntopng default credentials are user='admin' password='admin'"
}
