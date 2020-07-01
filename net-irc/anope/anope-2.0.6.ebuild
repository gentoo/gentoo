# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake user

DESCRIPTION="Anope IRC Services"
HOMEPAGE="https://anope.org"
SRC_URI="https://github.com/anope/anope/releases/download/${PV}/${P}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chanstats cs-fantasy-stats cs-fantasy-top gnutls irc2sql ldap
	ldap-auth ldap-oper mysql pcre posix sql-auth sql-log sql-oper
	sqlite ssl tre"

REQUIRED_USE="
	chanstats? ( mysql )
	cs-fantasy-stats? ( chanstats mysql )
	cs-fantasy-top? ( chanstats mysql )
	irc2sql? ( mysql )
	ldap-auth? ( ldap )
	ldap-oper? ( ldap )
	sql-auth? ( || ( mysql sqlite ) )
	sql-log? ( mysql )
	sql-oper? ( mysql )"

BDEPEND="sys-devel/gettext"
DEPEND="${BDEPEND}
	mysql? ( dev-db/mysql-connector-c:0= )
	ssl? ( dev-libs/openssl:0= )
	gnutls? ( net-libs/gnutls:0= dev-libs/libgcrypt:0= )
	ldap? ( net-nds/openldap )
	pcre? ( dev-libs/libpcre )
	sqlite? ( dev-db/sqlite:3 )
	tre? ( dev-libs/tre )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/anope-2.0.6-example.conf-pid-path.patch" )

S="${WORKDIR}/${P}-source"

pkg_pretend() {
	local replaced_version
	for replaced_version in ${REPLACING_VERSIONS} ; do
		if ver_test ${replaced_version} -lt 1.8.7 && [[ -f ${ROOT}/opt/anope/data/nick.db ]]; then
			eerror "It looks like you have an older version of Anope installed."
			eerror "To upgrade, shut down Anope and copy your databases to"
			eerror "${ROOT}/var/lib/anope and your configuration to ${ROOT}/etc/anope"
			eerror "You can do this by:"
			eerror "# mkdir -p ${ROOT}/var/lib/anope ${ROOT}/etc/anope"
			eerror "# chown anope:anope ${ROOT}/var/lib/anope"
			eerror "# mv ${ROOT}/opt/anope/data/*.db ${ROOT}/var/lib/anope"
			eerror "# mv ${ROOT}/opt/anope/data/services.conf ${ROOT}/etc/anope"
			die "Please move your anope database files from /opt/anope/data"
		fi
	done
}

pkg_setup() {
	enewgroup anope
	enewuser anope -1 -1 -1 anope
}

src_prepare() {
	anope_use_extra() {
		local useflag=$1
		local modulefile=$2
		if use $useflag; then
			ln -s "extra/${modulefile}" "modules/" || \
				die "Failed to use ${modulefile}"
		fi
	}

	anope_use_extra mysql			"m_mysql.cpp"
	anope_use_extra sqlite			"m_sqlite.cpp"
	anope_use_extra ssl			"m_ssl_openssl.cpp"
	anope_use_extra gnutls			"m_ssl_gnutls.cpp"
	anope_use_extra posix			"m_regex_posix.cpp"
	anope_use_extra pcre			"m_regex_pcre.cpp"
	anope_use_extra tre			"m_regex_tre.cpp"
	anope_use_extra ldap			"m_ldap.cpp"
	anope_use_extra sql-auth		"m_sql_authentication.cpp"
	anope_use_extra sql-log			"m_sql_log.cpp"
	anope_use_extra sql-oper		"m_sql_oper.cpp"
	anope_use_extra ldap-auth		"m_ldap_authentication.cpp"
	anope_use_extra ldap-oper		"m_ldap_oper.cpp"
	anope_use_extra chanstats		"stats/m_chanstats.cpp"
	anope_use_extra cs-fantasy-top		"stats/cs_fantasy_top.cpp"
	anope_use_extra cs-fantasy-stats	"stats/cs_fantasy_stats.cpp"
	anope_use_extra irc2sql			"stats/irc2sql/irc2sql.cpp"
	anope_use_extra irc2sql			"stats/irc2sql/irc2sql.h"
	anope_use_extra irc2sql			"stats/irc2sql/tables.cpp"
	anope_use_extra irc2sql			"stats/irc2sql/utils.cpp"

	# Avoid a silly sandbox error - tries to delete /usr/lib/modules
	sed -i '/install.*REMOVE_RECURSE.*/d' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBIN_DIR="libexec/anope"
		-DDB_DIR="../var/lib/anope"
		-DDOC_DIR="share/doc/${PF}"
		-DLIB_DIR="$(get_libdir)/anope"
		-DLOCALE_DIR="share/locale"
		-DCONF_DIR="/etc/anope"
		-DLOGS_DIR="../var/log/anope/"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}/anope-init.d" "${PN}"
	cp "${FILESDIR}/anope-conf.d-v2" "${T}" || die
	sed -i "s~%LIBDIR%~${EPREFIX}/usr/$(get_libdir)/anope/~" \
		 "${T}/anope-conf.d-v2" || die
	newconfd "${T}/anope-conf.d-v2" "${PN}"
	dosym ../libexec/anope/services /usr/bin/services
	dosym ../libexec/anope/anopesmtp /usr/bin/anopesmtp
	keepdir /var/log/anope /var/lib/anope/backups
	fowners anope:anope /var/{lib,log}/anope /var/lib/anope/backups
	dodoc -r docs/* data/example.conf
	insinto /etc/anope
	newins data/example.conf services.conf
	fowners -R anope:anope /etc/anope
	fperms -R 0700 /etc/anope
	fperms 0755 /var/log/anope
	fperms -R 0750 /var/lib/anope
}

pkg_preinst() {
	if [[ -n ${REPLACING_VERSIONS} ]] ; then
		local directory
		directory="${ROOT}"/var/lib/anope/pre-update
		elog "Making a backup of your databases to ${directory}"
		if [ ! -d "${directory}" ]; then
			mkdir -p "${directory}" || die "failed to create backup directory"
			chown anope:anope "${directory}"/../ || die "failed to chown data directory"
		fi
		# don't die otherwise merge will fail if there are no existing databases
		cp "${ROOT}"/var/lib/anope/*.db "${directory}"
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog
		ewarn "Anope won't run out of the box, you still have to configure it to match your IRCD's configuration."
		ewarn "Edit /etc/anope/services.conf to configure Anope."
		elog
	fi
}
