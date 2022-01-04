# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam rebar systemd

DESCRIPTION="Robust, scalable and extensible XMPP server"
HOMEPAGE="https://www.ejabberd.im/ https://github.com/processone/ejabberd/"
SRC_URI="https://static.process-one.net/${PN}/downloads/${PV}/${P}.tgz
	-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~sparc ~x86"
REQUIRED_USE="mssql? ( odbc )"
# TODO: Add 'tools' flag.
IUSE="captcha debug full-xml ldap mssql mysql odbc pam postgres redis
	roster-gw selinux sip sqlite +stun zlib"

RESTRICT="test"

# TODO: Add dependencies for 'tools' flag enabled.
# TODO: tools? (
# TODO:		>=dev-erlang/luerl-0.3
# TODO: )
DEPEND=">=dev-lang/erlang-19.3[odbc?,ssl]
	>=dev-erlang/cache_tab-1.0.28
	>=dev-erlang/eimp-1.0.20
	>=dev-erlang/fast_tls-1.1.12
	>=dev-erlang/fast_xml-1.1.46
	>=dev-erlang/fast_yaml-1.0.31
	>=dev-erlang/yconf-1.0.11
	>=dev-erlang/jiffy-1.0.5
	>=dev-erlang/jose-1.9.0
	>=dev-erlang/lager-3.6.10
	>=dev-erlang/p1_oauth2-0.6.9
	>=dev-erlang/p1_utils-1.0.22
	>=dev-erlang/stringprep-1.0.25
	>=dev-erlang/xmpp-1.5.3
	>=dev-erlang/pkix-1.0.7
	>=dev-erlang/mqtree-1.0.13
	>=dev-erlang/idna-6.0.0-r1
	>=dev-erlang/p1_acme-1.0.12
	>=dev-erlang/base64url-1.0.1
	ldap? ( =net-nds/openldap-2* )
	mysql? ( >=dev-erlang/p1_mysql-1.0.18 )
	odbc? ( dev-db/unixODBC )
	pam? ( >=dev-erlang/epam-1.0.10 )
	postgres? ( >=dev-erlang/p1_pgsql-1.1.11 )
	redis? ( >=dev-erlang/eredis-1.0.8 )
	sip? ( >=dev-erlang/esip-1.0.42 )
	sqlite? ( >=dev-erlang/sqlite3-1.1.12 )
	stun? ( >=dev-erlang/stun-1.0.43 )
	zlib? ( >=dev-erlang/ezlib-1.0.9 )"
RDEPEND="${DEPEND}
	acct-user/ejabberd
	captcha? ( media-gfx/imagemagick[truetype,png] )
	selinux? ( sec-policy/selinux-jabber )
"

DOCS=( CHANGELOG.md README.md )
PATCHES=( "${FILESDIR}/${PN}-19.08-ejabberdctl.patch"
	"${FILESDIR}/${PN}-17.04-0002-Dont-overwrite-service-file.patch")

# Set paths to ejabberd lib directory consistently to point always to directory
# suffixed with version.
correct_ejabberd_paths() {
	sed -e "/^EJABBERDDIR[[:space:]]*=/{s:ejabberd:${P}:}" \
		-i "${S}/Makefile.in" \
		|| die 'failed to set ejabberd path in Makefile.in'
	sed -e "/EJABBERD_BIN_PATH=/{s:ejabberd:${P}:}" \
		-i "${S}/ejabberdctl.template" \
		|| die 'failed to set ejabberd path in ejabberdctl.template'
}

# Get epam-wrapper from 'files' directory and correct path to lib directory in
# it. epam-wrapper is placed into work directory. It is assumed no epam-wrapper
# file exists there already.
customize_epam_wrapper() {
	local epam_wrapper_src="${1}"
	local epam_wrapper_dst="${S}/epam-wrapper"

	[[ -e ${epam_wrapper_dst} ]] && die 'epam-wrapper already exists'
	sed -r -e "s@^(ERL_LIBS=).*\$@\1${EPREFIX}$(get_erl_libs)@" \
		"${epam_wrapper_src}" >"${epam_wrapper_dst}" \
		|| die 'failed to install epam-wrapper'
}

# Get path to ejabberd lib directory.
#
# This is the path ./configure script Base for this path is path set in
# ./configure script which is /usr/lib by default. If libdir is explicitely set
# to something else than this should be adjusted here as well.
get_ejabberd_path() {
	echo "/usr/$(get_libdir)/${P}"
}

# Make ejabberd.service for systemd from upstream provided template.
make_ejabberd_service() {
	sed -r \
		-e 's!@ctlscriptpath@!/usr/sbin!g' \
		-e 's!^(After)=(.*)!\1=epmd.service network.target!' \
		-e '/^After=/ a Requires=epmd.service' \
		"${PN}.service.template" >"${PN}.service" \
		|| die 'failed to make ejabberd.service'
}

src_prepare() {
	default

	rebar_remove_deps
	correct_ejabberd_paths
	make_ejabberd_service
	customize_epam_wrapper "${FILESDIR}/epam-wrapper"

	rebar_fix_include_path fast_xml
	rebar_fix_include_path p1_utils
	rebar_fix_include_path xmpp

	# Fix bug #591862. ERL_LIBS should point directly to ejabberd directory
	# rather than its parent which is default. That way ejabberd directory
	# takes precedence is module lookup.
	local ejabberd_erl_libs="$(get_ejabberd_path):$(get_erl_libs)"
	sed -e "s|\(ERL_LIBS=\){{libdir}}.*|\1${ejabberd_erl_libs}|" \
		-i "${S}/ejabberdctl.template" \
		|| die 'failed to set ERL_LIBS in ejabberdctl.template'
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--localstatedir="${EPREFIX}/var" \
		--enable-user=${PN} \
		$(use_enable debug) \
		$(use_enable full-xml) \
		$(use_enable mssql) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable pam) \
		$(use_enable postgres pgsql) \
		$(use_enable redis) \
		$(use_enable roster-gw roster-gateway-workaround) \
		$(use_enable sqlite) \
		$(use_enable sip) \
		$(use_enable stun) \
		$(use_enable zlib)

	# more options to support
	# --enable-elixir requires https://github.com/elixir-lang/elixir
}

src_compile() {
	emake REBAR='rebar -v' src
}

src_install() {
	default

	if use pam; then
		local epam_path="$(get_ejabberd_path)/priv/bin/epam"

		pamd_mimic_system xmpp auth account
		into "$(get_ejabberd_path)/priv"
		newbin epam-wrapper epam
	fi

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${PN}.service"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	# /var/lock/ejabberdctl is unused, see
	# https://github.com/processone/ejabberd/pull/3724
	rmdir "${ED}/var/lock/ejabberdctl" || die
	rmdir "${ED}/var/lock" || die

	keepdir /var/{lib,log}/ejabberd
}

pkg_preinst() {
	if use pam; then
		einfo "Adding ejabberd user to epam group to allow ejabberd to use PAM" \
			"authentication"
		# See
		# <https://docs.ejabberd.im/admin/configuration/#pam-authentication>.
		# epam binary is installed by dev-erlang/epam package, therefore SUID
		# is set by that package. Instead of jabber group it uses epam group,
		# therefore we need to add jabber user to epam group.
		usermod -a -G epam ejabberd || die
	fi
}

pkg_postinst() {
	local migrate_to_ejabberd_user=false

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		echo
		elog "For configuration instructions, please see"
		elog "  https://docs.ejabberd.im/"
		echo
	else
		for v in ${REPLACING_VERSIONS}; do
			if ver_test "${v}" -lt 21.04-r1; then
				migrate_to_ejabberd_user=true
				break
			fi
		done
	fi

	# Sarting with >=21.04-r1, the ejabberd configuration is now in
	# /etc/ejabberd and no longer in /etc/jabber. See if we need to
	# migrate the configuration. Furthermore, ejabberd no longer runs
	# under the, shared via net-im/jabber-base, 'jabber' use, but under
	# its own user. This increase isolation and hence robustness and
	# security.
	if $migrate_to_ejabberd_user; then
		local -A dirs_to_migrate=(
			[/etc/jabber]=/etc/ejabberd
			[/var/spool/jabber]=/var/lib/ejabberd
		)

		for src_dir in "${!dirs_to_migrate[@]}"; do
			local eroot_src_dir="${EROOT}${src_dir}"
			local eroot_dst_dir="${EROOT}${dirs_to_migrate[${src_dir}]}"

			cp -r "${eroot_src_dir}"/. "${eroot_dst_dir}" || die "Could not copy ${eroot_src_dir} to ${eroot_dst_dir}"

			if [[ -f "${eroot_dst_dir}"/.keep_net-im_jabber-base-0 ]]; then
				rm "${eroot_dst_dir}"/.keep_net-im_jabber-base-0 || die
			fi
			if ! use prefix; then
				chown --recursive ejabberd:ejabberd "${eroot_dst_dir}" || die
			fi
		done

		ewarn "Newer versions of the ejabberd Gentoo package use /etc/ejabberd"
		ewarn "(just as upstream) and *not* /etc/ejabber."
		ewarn "The files from /etc/jabber where copied to /etc/ejabberd."
		ewarn "Also ejabberd's spool directory became /var/lib/ejabberd (was /var/spool/jabber)."
		ewarn "Please check your configuration."
	fi
}
