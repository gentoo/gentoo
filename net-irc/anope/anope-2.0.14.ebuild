# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Anope IRC Services"
HOMEPAGE="https://anope.org/ https://github.com/anope/anope/"
SRC_URI="https://github.com/anope/anope/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="gnutls ldap mysql pcre sql sqlite ssl tre"
REQUIRED_USE="sql? ( || ( mysql sqlite ) )"

DEPEND="
	acct-group/anope
	acct-user/anope
	mysql? ( dev-db/mysql-connector-c:= )
	ssl? ( dev-libs/openssl:= )
	gnutls? (
		net-libs/gnutls:=
		dev-libs/libgcrypt:=
	)
	ldap? ( net-nds/openldap:= )
	pcre? ( dev-libs/libpcre2 )
	sqlite? ( dev-db/sqlite:3 )
	tre? ( dev-libs/tre )
	virtual/libintl
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.6-example.conf-pid-path.patch"
	"${FILESDIR}/${PN}-2.0.7-example.conf-user.patch"
)

src_prepare() {
	anope_enable_mod() {
		local modulefile=${1}
		ln -s "extra/${modulefile}" "modules/" || \
			die "Failed to use ${modulefile}"
	}

	# These all require MySQL specifically
	if use mysql ; then
		anope_enable_mod "m_mysql.cpp"
		anope_enable_mod "stats/irc2sql/irc2sql.cpp"
		anope_enable_mod "stats/irc2sql/irc2sql.h"
		anope_enable_mod "stats/irc2sql/tables.cpp"
		anope_enable_mod "stats/irc2sql/utils.cpp"
		anope_enable_mod "stats/m_chanstats.cpp"
		anope_enable_mod "stats/cs_fantasy_top.cpp"
		anope_enable_mod "stats/cs_fantasy_stats.cpp"
		anope_enable_mod "m_sql_log.cpp"
		anope_enable_mod "m_sql_oper.cpp"
	fi

	use sqlite && anope_enable_mod "m_sqlite.cpp"

	# Any SQL implementation
	if use sql ; then
		anope_enable_mod "m_sql_authentication.cpp"
	fi

	if use ldap ; then
		anope_enable_mod "m_ldap.cpp"
		anope_enable_mod "m_ldap_authentication.cpp"
		anope_enable_mod "m_ldap_oper.cpp"
	fi

	use gnutls && anope_enable_mod "m_ssl_gnutls.cpp"
	use pcre && anope_enable_mod "m_regex_pcre2.cpp"
	use ssl && anope_enable_mod "m_ssl_openssl.cpp"
	use tre && anope_enable_mod "m_regex_tre.cpp"

	# Unconditional modules
	anope_enable_mod "m_regex_posix.cpp"

	# Avoid a silly sandbox error - tries to delete /usr/lib/modules
	sed -i '/install.*REMOVE_RECURSE.*/d' CMakeLists.txt || die

	# Copy anope.conf for fixup to comply w/ prefix
	cp "${FILESDIR}"/anope-conf.d-v2 "${T}" || die

	# Look in the right place for modules
	sed -i "s~%LIBDIR%~${EPREFIX}/usr/$(get_libdir)/anope/~" \
		"${T}"/anope-conf.d-v2 || die

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

	# https://gitlab.kitware.com/cmake/cmake/-/issues/24237
	# https://bugs.anope.org/view.php?id=1753
	unset CLICOLOR CLICOLOR_FORCE CMAKE_COMPILER_COLOR_DIAGNOSTICS CMAKE_COLOR_DIAGNOSTICS

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/anope-init.d ${PN}
	newconfd "${T}"/anope-conf.d-v2 ${PN}

	dosym ../libexec/anope/services /usr/bin/services
	dosym ../libexec/anope/anopesmtp /usr/bin/anopesmtp

	keepdir /var/log/anope /var/lib/anope/backups
	fowners anope:anope /var/{lib,log}/anope /var/lib/anope/backups

	dodoc -r docs/* data/example.conf

	insinto /etc/anope
	newins data/example.conf services.conf

	fowners anope:anope /var/log/anope
	fowners anope:anope /var/lib/anope/backups/
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		# Only tell them about this on a fresh install.
		ewarn "Anope won't run out of the box, you still have to configure it to match your IRCd's configuration."
		ewarn "Edit /etc/anope/services.conf to configure Anope."
	else
		# We're replacing some versions. Find out which.
		local ver
		for ver in ${REPLACING_VERSIONS} ; do
			if ver_test ${ver} -lt 2.0.7 ; then
				# In this version, we introduced correct FHS structure
				# We need the users to make some changes to their services.conf
				ewarn "Please modify your services.conf to include the following directive:"
				ewarn "in options{}, please include user=\"anope\" and group=\"anope\""
				ewarn "This is needed because Anope now starts as root and drops down."
				ewarn "Reference: https://wiki.anope.org/index.php/2.0/Configuration#Services_Process_Options"
			fi
		done
	fi
}
