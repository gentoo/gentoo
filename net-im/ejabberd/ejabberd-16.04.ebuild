# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

SSL_CERT_MANDATORY=1

inherit eutils pam rebar ssl-cert systemd

DESCRIPTION="Robust, scalable and extensible XMPP server"
HOMEPAGE="http://www.ejabberd.im/ https://github.com/processone/ejabberd/"
SRC_URI="http://www.process-one.net/downloads/${PN}/${PV}/${P}.tgz
	-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
REQUIRED_USE="mssql? ( odbc )"
# TODO: Add 'tools' flag.
IUSE="captcha debug full-xml hipe ldap mssql mysql nls odbc pam postgres redis
	riak roster-gw sqlite zlib"

RESTRICT="test"

# TODO: Add dependencies for 'tools' flag enabled.
# TODO: tools? (
# TODO: 	>=dev-erlang/meck-0.8.4
# TODO: 	>=dev-erlang/moka-1.0.5b
# TODO: )
CDEPEND="
	>=dev-erlang/cache_tab-1.0.2
	>=dev-erlang/esip-1.0.4
	>=dev-erlang/fast_tls-1.0.3
	>=dev-erlang/fast_xml-1.1.3
	>=dev-erlang/fast_yaml-1.0.3
	>=dev-erlang/jiffy-0.14.7
	>=dev-erlang/lager-3.0.2
	>=dev-erlang/luerl-0.2
	>=dev-erlang/p1_oauth2-0.6.1
	>=dev-erlang/p1_utils-1.0.4
	>=dev-erlang/p1_xmlrpc-1.15.1
	>=dev-erlang/stringprep-1.0.3
	>=dev-erlang/stun-1.0.3
	>=dev-lang/erlang-17.1[hipe?,odbc?,ssl]
	<dev-lang/erlang-19
	>=net-im/jabber-base-0.01
	ldap? ( =net-nds/openldap-2* )
	mysql? ( >=dev-erlang/p1_mysql-1.0.1 )
	nls? ( >=dev-erlang/iconv-1.0.0 )
	odbc? ( dev-db/unixODBC )
	pam? ( >=dev-erlang/p1_pam-1.0.0 )
	postgres? ( >=dev-erlang/p1_pgsql-1.1.0 )
	redis? ( >=dev-erlang/eredis-1.0.8 )
	riak? (
		>=dev-erlang/hamcrest-0.1.0_p20150103
		>=dev-erlang/riakc-2.1.1_p20151111
	)
	sqlite? ( >=dev-erlang/sqlite3-1.1.5 )
	zlib? ( >=dev-erlang/ezlib-1.0.1 )"
DEPEND="${CDEPEND}
	>=sys-apps/gawk-4.1"
RDEPEND="${CDEPEND}
	captcha? ( media-gfx/imagemagick[truetype,png] )"

DOCS=( README )
PATCHES=( "${FILESDIR}/${P}-ejabberdctl.patch" )

EJABBERD_CERT="${EPREFIX}/etc/ssl/ejabberd/server.pem"
# Paths in net-im/jabber-base
JABBER_ETC="${EPREFIX}/etc/jabber"
JABBER_LOG="${EPREFIX}/var/log/jabber"
JABBER_SPOOL="${EPREFIX}/var/spool/jabber"

# Adjust example configuration file to Gentoo.
# - Use our sample certificates.
# - Correct PAM service name.
adjust_config() {
	sed -e "s|\"/path/to/ssl.pem\"|\"${EJABBERD_CERT}\"|g" \
		-e "s|\"pamservicename\"|\"xmpp\"|" \
		-i "${S}/ejabberd.yml.example" \
		|| die 'failed to adjust example config'
}

# Set paths to ejabberd lib directory consistently to point always to directory
# suffixed with version.
correct_ejabberd_paths() {
	sed -e "/^EJABBERDDIR[[:space:]]*=/{s:ejabberd:${P}:}" \
		-i "${S}/Makefile.in" \
		|| die 'failed to set ejabberd path in Makefile.in'
	sed -e "/EJABBERD_BIN_PATH=/{s:ejabberd:${P}:}" \
		-i "${S}/ejabberdctl.template" \
		|| die 'failed to set ejabberd path in ejabberdctl.template'
	sed -e 's|\(captcha_cmd:[[:space:]]*"\).\+"|\1'$(get_ejabberd_path)'/priv/bin/captcha.sh"|' \
		-i "${S}/ejabberd.yml.example" \
		|| die 'failed to correct path to captcha.sh in example config'
}

# Get epam-wrapper from 'files' directory and correct path to lib directory in
# it. epam-wrapper is placed into work directory. It is assumed no epam-wrapper
# file exists there already.
customize_epam_wrapper() {
	local epam_wrapper_src="$1"
	local epam_wrapper_dst="${S}/epam-wrapper"

	[[ -e ${epam_wrapper_dst} ]] && die 'epam-wrapper already exists'
	sed -r -e "s@^(ERL_LIBS=).*\$@\1${EPREFIX}$(get_erl_libs)@" \
		"${epam_wrapper_src}" >"${epam_wrapper_dst}" \
		|| die 'failed to install epam-wrapper'
}

# Check if there already exists a certificate.
ejabberd_cert_exists() {
	local cert

	for cert in $(gawk -- \
			'match($0, /^[[:space:]]*certfile: "([^"]+)"/, m) {print m[1];}' \
			"${EROOT%/}${JABBER_ETC}/ejabberd.yml"); do
		[[ -f ${cert} ]] && return 0
	done

	return 1
}

# Generate and install sample ejabberd certificate. It's installed into
# EJABBERD_CERT path.
ejabberd_cert_install() {
	SSL_ORGANIZATION="${SSL_ORGANIZATION:-ejabberd XMPP Server}"
	install_cert "${EJABBERD_CERT%.*}"
	chown root:jabber "${EROOT%/}${EJABBERD_CERT}" || die
	chmod 0440 "${EROOT%/}${EJABBERD_CERT}" || die
}

# Get path to ejabberd lib directory.
get_ejabberd_path() {
	echo "$(get_erl_libs)/${P}"
}

# Make ejabberd.service for systemd from upstream provided template.
make_ejabberd_service() {
	sed -r \
		-e 's!@ctlscriptpath@!/usr/sbin!' \
		-e 's!(User|Group)=(.*)!\1=jabber!' \
		"${PN}.service.template" >"${PN}.service" \
		|| die 'failed to make ejabberd.service'
}

# Set paths to defined by net-im/jabber-base.
set_jabberbase_paths() {
	sed -e "/^ETCDIR[[:space:]]*=/{s:@sysconfdir@/ejabberd:${JABBER_ETC}:}" \
		-e "/^LOGDIR[[:space:]]*=/{s:@localstatedir@/log/ejabberd:${JABBER_LOG}:}" \
		-e "/^SPOOLDIR[[:space:]]*=/{s:@localstatedir@/lib/ejabberd:${JABBER_SPOOL}:}" \
		-i "${S}/Makefile.in" \
		|| die 'failed to set paths in Makefile.in'
	sed -e "s|\(ETC_DIR=\){{sysconfdir}}.*|\1${JABBER_ETC}|" \
		-e "s|\(LOGS_DIR=\){{localstatedir}}.*|\1${JABBER_LOG}|" \
		-e "s|\(SPOOL_DIR=\){{localstatedir}}.*|\1${JABBER_SPOOL}|" \
		-i "${S}/ejabberdctl.template" \
		|| die 'failed to set paths ejabberdctl.template'
}

# Skip installing docs because it's only COPYING that's installed by Makefile.
skip_docs() {
	gawk -i inplace '
/# Documentation/, /^[[:space:]]*#?[[:space:]]*$/ {
	if ($0 ~ /^[[:space:]]*#?[[:space:]]*$/) {
		print $0;
	} else {
		next;
	}
}
1
' "${S}/Makefile.in" || die 'failed to remove docs section from Makefile.in'
}

src_prepare() {
	default

	rebar_remove_deps
	correct_ejabberd_paths
	set_jabberbase_paths
	make_ejabberd_service
	skip_docs
	adjust_config
	customize_epam_wrapper "${FILESDIR}/epam-wrapper"
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--libdir="${EPREFIX}$(get_erl_libs)" \
		--enable-user=jabber \
		$(use_enable debug) \
		$(use_enable full-xml) \
		$(use_enable hipe) \
		$(use_enable mssql) \
		$(use_enable mysql) \
		$(use_enable nls iconv) \
		$(use_enable odbc) \
		$(use_enable pam) \
		$(use_enable postgres pgsql) \
		$(use_enable redis) \
		$(use_enable riak) \
		$(use_enable roster-gw roster-gateway-workaround) \
		$(use_enable sqlite) \
		$(use_enable zlib)
}

src_compile() {
	emake REBAR='rebar -v' src
}

src_install() {
	default

	if use pam; then
		local epam_path="$(get_ejabberd_path)/priv/bin/epam"

		pamd_mimic_system xmpp auth account || die "cannot create pam.d file"
		into "$(get_ejabberd_path)/priv"
		newbin epam-wrapper epam
		# PAM helper module permissions
		# https://www.process-one.net/docs/ejabberd/guide_en.html#pam
		fowners root:jabber "${epam_path}"
		fperms 4750 "${epam_path}"
	fi

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${PN}.service"
	systemd_dotmpfilesd "${FILESDIR}/${PN}.tmpfiles.conf"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		echo
		elog "For configuration instructions, please see"
		elog "  http://www.process-one.net/en/ejabberd/docs/"
		echo
		if [[ " ${REPLACING_VERSIONS} " =~ \ 2\. ]]; then
			ewarn "If you have used pubsub in ejabberd-2.* you may encounter issues after"
			ewarn "migration to ${PV}. pubsub data may not be migrated automatically and"
			ewarn "you may need to run migration script manually, see:"
			ewarn
			ewarn "  https://github.com/processone/ejabberd/issues/479#issuecomment-124497456"
			ewarn
			ewarn "In case you don't care about all stored moods, activities, geoinfo and you"
			ewarn "know you don't store in pubsub anything important, you can just remove"
			ewarn "pubsub tables:"
			ewarn
			ewarn "  rm ${EROOT%/}${JABBER_SPOOL}/pubsub_*"
			ewarn
			ewarn "See also: https://bugs.gentoo.org/show_bug.cgi?id=588244"
			echo
		fi
	elif [[ -f ${EROOT}etc/jabber/ejabberd.cfg ]]; then
		elog "Ejabberd now defaults to using a YAML format for its config file."
		elog "The old ejabberd.cfg file can be converted using the following instructions:"
		echo
		elog "1. Make sure all processes related to the previous version of ejabberd aren't"
		elog "   running. Usually this just means the ejabberd and epmd daemons and possibly"
		elog "   the pam-related process (epam) if pam support is enabled."
		elog "2. Run \`ejabberdctl start\` with sufficient permissions. Note that this can"
		elog "   fail to start ejabberd properly for various reasons. Check ejabberd's main"
		elog "   log file at /var/log/jabber/ejabberd.log to confirm it started successfully."
		elog "3. Run"
		elog "     \`ejabberdctl convert_to_yaml /etc/jabber/ejabberd.cfg /etc/jabber/ejabberd.yml.new\`"
		elog "   with sufficient permissions, edit and rename /etc/jabber/ejabberd.yml.new to"
		elog "   /etc/jabber/ejabberd.yml, and finally restart ejabberd with the new config"
		elog "   file."
		echo
	fi

	if ! ejabberd_cert_exists; then
		ejabberd_cert_install
	fi
}
