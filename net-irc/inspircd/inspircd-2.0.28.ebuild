# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Inspire IRCd - The Stable, High-Performance Modular IRCd"
HOMEPAGE="https://inspircd.github.com/"
SRC_URI="https://github.com/inspircd/inspircd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="geoip gnutls ipv6 ldap mysql pcre posix postgres sqlite ssl tre"

RDEPEND="
	acct-group/inspircd
	acct-user/inspircd
	dev-lang/perl
	ssl? ( dev-libs/openssl:= )
	geoip? ( dev-libs/geoip )
	gnutls? ( net-libs/gnutls:= dev-libs/libgcrypt:0 )
	ldap? ( net-nds/openldap )
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:= )
	pcre? ( dev-libs/libpcre )
	sqlite? ( >=dev-db/sqlite-3.0 )
	tre? ( dev-libs/tre )"
DEPEND="${RDEPEND}"

DOCS=( docs/. )
PATCHES=( "${FILESDIR}"/${PN}-2.0.27-fix-path-builds.patch )

src_prepare() {
	default

	# Patch the inspircd launcher with the inspircd user
	sed -i -e "s/@UID@/${PN}/" "${S}/make/template/${PN}" || die
}

src_configure() {
	local extras=""

	use geoip && extras+="m_geoip.cpp,"
	use gnutls && extras+="m_ssl_gnutls.cpp,"
	use ldap && extras+="m_ldapauth.cpp,m_ldapoper.cpp,"
	use mysql && extras+="m_mysql.cpp,"
	use pcre && extras+="m_regex_pcre.cpp,"
	use posix && extras+="m_regex_posix.cpp,"
	use postgres && extras+="m_pgsql.cpp,"
	use sqlite && extras+="m_sqlite3.cpp,"
	use ssl && extras+="m_ssl_openssl.cpp,"
	use tre && extras+="m_regex_tre.cpp,"

	# The first configuration run enables certain "extra" InspIRCd
	# modules, the second run generates the actual makefile.
	if [[ -n "${extras}" ]]; then
		./configure --disable-interactive --enable-extras=${extras%,}
	fi

	local myconf=(
		--with-cc="$(tc-getCXX)"
		--disable-interactive
		--prefix="/usr/$(get_libdir)/${PN}"
		--config-dir="/etc/${PN}"
		--data-dir="/var/lib/${PN}/data"
		--log-dir="/var/log/${PN}"
		--binary-dir="/usr/bin"
		--module-dir="/usr/$(get_libdir)/${PN}/modules"
		$(usex ipv6 '' '--disable-ipv6')
		$(usex gnutls '--enable-gnutls' '')
		$(usex ssl '--enable-openssl' ''))
	./configure "${myconf[@]}"
}

src_compile() {
	emake V=1 LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake INSTUID=${PN} DESTDIR="${D%/}" install

	insinto "/usr/include/${PN}"
	doins -r include/.

	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "/var/log/${PN}"

	diropts -o"${PN}" -g"${PN}" -m0700
	keepdir "/var/lib/${PN}/data"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "You will find example configuration files under "
		elog "/usr/share/doc/${PN}"
		elog "Read the ${PN}.conf.example file carefully before "
		elog "starting the service."
	fi
	local pv
	for pv in ${REPLACING_VERSIONS}; do
		if ver_test "${pv}" -lt "2.0.24-r1"; then
			elog "Starting with 2.0.24-r1 the daemon is no longer started"
			elog "with the --logfile option and you are thus expected to define"
			elog "logging in the InspIRCd configuration file if you want it."
			break
		fi
	done
}
