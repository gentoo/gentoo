# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} )

inherit autotools linux-info lua-single systemd toolchain-funcs tmpfiles

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="https://www.asterisk.org/"
SRC_URI="https://downloads.asterisk.org/pub/telephony/asterisk/releases/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0/${PV%%.*}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

IUSE_VOICEMAIL_STORAGE=(
	+voicemail_storage_file
	voicemail_storage_odbc
	voicemail_storage_imap
)
IUSE="${IUSE_VOICEMAIL_STORAGE[*]//+/} alsa blocks bluetooth calendar +caps cluster curl dahdi debug doc freetds gtalk http iconv ilbc ldap libressl lua mysql newt odbc oss pjproject portaudio postgres radius selinux snmp span speex srtp +ssl static statsd syslog vorbis xmpp"
REQUIRED_USE="gtalk? ( xmpp )
	lua? ( ${LUA_REQUIRED_USE} )
	^^ ( ${IUSE_VOICEMAIL_STORAGE[*]//+/} )
	voicemail_storage_odbc? ( odbc )
"

PATCHES=(
	"${FILESDIR}/asterisk-historic-no-var-run-install.patch"
	"${FILESDIR}/asterisk-13.38.1-r1-autoconf-lua-version.patch"
	"${FILESDIR}/asterisk-13.38.1-r1-func_lock-fix-races.patch"
	"${FILESDIR}/asterisk-13.18.1-r2-autoconf-2.70.patch"
)

DEPEND="acct-user/asterisk
	acct-group/asterisk
	dev-db/sqlite:3
	dev-libs/popt
	dev-libs/jansson
	dev-libs/libedit
	dev-libs/libxml2:2
	dev-libs/libxslt
	sys-libs/ncurses:0=
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez:= )
	calendar? (
		net-libs/neon:=
		dev-libs/libical:=
		dev-libs/iksemel
	)
	caps? ( sys-libs/libcap )
	blocks? ( sys-libs/blocksruntime )
	cluster? ( sys-cluster/corosync )
	curl? ( net-misc/curl )
	dahdi? (
		net-libs/libpri
		net-misc/dahdi-tools
	)
	freetds? ( dev-db/freetds )
	gtalk? ( dev-libs/iksemel )
	http? ( dev-libs/gmime:2.6 )
	iconv? ( virtual/libiconv )
	ilbc? ( media-libs/libilbc )
	ldap? ( net-nds/openldap )
	lua? ( ${LUA_DEPS} )
	mysql? ( dev-db/mysql-connector-c:= )
	newt? ( dev-libs/newt )
	odbc? ( dev-db/unixODBC )
	pjproject? ( net-libs/pjproject )
	portaudio? ( media-libs/portaudio )
	postgres? ( dev-db/postgresql:* )
	radius? ( net-dialup/freeradius-client )
	snmp? ( net-analyzer/net-snmp:= )
	span? ( media-libs/spandsp )
	speex? (
		media-libs/libogg
		media-libs/speex
		media-libs/speexdsp
	)
	srtp? ( net-libs/libsrtp:0 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	voicemail_storage_imap? ( virtual/imap-c-client )
	xmpp? ( dev-libs/iksemel )
"

RDEPEND="${DEPEND}
	net-misc/asterisk-core-sounds
	net-misc/asterisk-extra-sounds
	net-misc/asterisk-moh-opsound
	selinux? ( sec-policy/selinux-asterisk )
	syslog? ( virtual/logger )"

BDEPEND="virtual/pkgconfig"

QA_DT_NEEDED="/usr/lib.*/libasteriskssl[.]so[.][0-9]\+"

pkg_pretend() {
	CONFIG_CHECK="~!NF_CONNTRACK_SIP"
	local WARNING_NF_CONNTRACK_SIP="SIP (NAT) connection tracking is enabled. Some users
	have reported that this module dropped critical SIP packets in their deployments. You
	may want to disable it if you see such problems."
	check_extra_config

	[[ "${MERGE_TYPE}" == binary ]] && return

	if tc-is-clang; then
		use blocks || die "CC=clang requires USE=blocks"
	else
		use blocks && die "USE=blocks can only be used with CC=clang"
	fi
}

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	AT_M4DIR="autoconf third-party third-party/pjproject third-party/jansson" eautoreconf
}

src_configure() {
	local vmst

	econf \
		LUA_VERSION="${ELUA#lua}" \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-crypto \
		--with-gsm=internal \
		--with-popt \
		--with-z \
		--with-libedit \
		$(use_with caps cap) \
		$(use_with lua lua) \
		$(use_with http gmime) \
		$(use_with newt) \
		$(use_with pjproject) \
		$(use_with portaudio) \
		$(use_with ssl)

	_menuselect() {
		menuselect/menuselect "$@" || die "menuselect $* failed."
	}

	_use_select() {
		local state=$(usex "$1" enable disable)
		shift # remove use from parameters

		while [[ -n $1 ]]; do
			_menuselect --${state} "$1" menuselect.makeopts
			shift
		done
	}

	# Blank out sounds/sounds.xml file to prevent
	# asterisk from installing sounds files (we pull them in via
	# asterisk-{core,extra}-sounds and asterisk-moh-opsound.
	>"${S}"/sounds/sounds.xml

	# That NATIVE_ARCH chatter really is quite bothersome
	sed -i 's/NATIVE_ARCH=/NATIVE_ARCH=0/' build_tools/menuselect-deps || die "Unable to squelch noisy build system"

	# Compile menuselect binary for optional components
	emake NOISE_BUILD=yes menuselect.makeopts

	# Disable BUILD_NATIVE (bug #667498)
	_menuselect --disable build_native menuselect.makeopts

	# Broken functionality is forcibly disabled (bug #360143)
	_menuselect --disable chan_misdn menuselect.makeopts
	_menuselect --disable chan_ooh323 menuselect.makeopts

	# Utility set is forcibly enabled (bug #358001)
	_menuselect --enable smsq menuselect.makeopts
	_menuselect --enable streamplayer menuselect.makeopts
	_menuselect --enable aelparse menuselect.makeopts
	_menuselect --enable astman menuselect.makeopts

	# this is connected, otherwise it would not find
	# ast_pktccops_gate_alloc symbol
	_menuselect --enable chan_mgcp menuselect.makeopts
	_menuselect --enable res_pktccops menuselect.makeopts

	# SSL is forcibly enabled, IAX2 & DUNDI are expected to be available
	_menuselect --enable pbx_dundi menuselect.makeopts
	_menuselect --enable func_aes menuselect.makeopts
	_menuselect --enable chan_iax2 menuselect.makeopts

	# SQlite3 is now the main database backend, enable related features
	_menuselect --enable cdr_sqlite3_custom menuselect.makeopts
	_menuselect --enable cel_sqlite3_custom menuselect.makeopts

	# The others are based on USE-flag settings
	_use_select alsa         chan_alsa
	_use_select bluetooth    chan_mobile
	_use_select calendar     res_calendar res_calendar_{caldav,ews,exchange,icalendar}
	_use_select cluster      res_corosync
	_use_select curl         func_curl res_config_curl res_curl
	_use_select dahdi        app_dahdiras app_meetme chan_dahdi codec_dahdi res_timing_dahdi
	_use_select freetds      {cdr,cel}_tds
	_use_select gtalk        chan_motif
	_use_select http         res_http_post
	_use_select iconv        func_iconv
	_use_select ilbc         codec_ilbc format_ilbc
	_use_select ldap         res_config_ldap
	_use_select lua          pbx_lua
	_use_select mysql        app_mysql cdr_mysql res_config_mysql
	_use_select odbc         cdr_adaptive_odbc res_config_odbc {cdr,cel,res,func}_odbc
	_use_select oss          chan_oss
	_use_select postgres     {cdr,cel}_pgsql res_config_pgsql
	_use_select radius       {cdr,cel}_radius
	_use_select snmp         res_snmp
	_use_select span         res_fax_spandsp
	_use_select speex        {codec,func}_speex
	_use_select speex        format_ogg_speex
	_use_select srtp         res_srtp
	_use_select statsd       res_statsd res_{endpoint,chan}_stats
	_use_select syslog       cdr_syslog
	_use_select vorbis       format_ogg_vorbis
	_use_select xmpp         res_xmpp

	# Voicemail storage ...
	for vmst in "${IUSE_VOICEMAIL_STORAGE[@]}"; do
		if use "${vmst#+}"; then
			_menuselect --enable "$(echo "${vmst##*_}" | tr '[:lower:]' '[:upper:]')_STORAGE" menuselect.makeopts
		fi
	done

	if use debug; then
		for o in DONT_OPTIMIZE DEBUG_THREADS BETTER_BACKTRACES; do
			_menuselect --enable $o menuselect.makeopts
		done
	fi
}

src_compile() {
	emake ASTCFLAGS="${CFLAGS}" ASTLDFLAGS="${LDFLAGS}" NOISY_BUILD=yes
}

src_install() {
	local d

	dodir "/usr/$(get_libdir)/pkgconfig"
	emake DESTDIR="${D}" NOISY_BUILD=yes install

	if use radius; then
		insinto /etc/radiusclient/
		doins contrib/dictionary.digium
	fi
	diropts -m 0750 -o root -g asterisk
	keepdir	/etc/asterisk
	emake NOISY_BUILD=yes DESTDIR="${D}" CONFIG_SRC=configs/samples CONFIG_EXTEN=.sample install-configs
	chown root:root "${ED}/etc/asterisk/"* || die "chown root:root of config files failed"
	chmod 644 "${ED}/etc/asterisk/"* || die "chmod 644 of config files failed"

	# keep directories
	diropts -m 0750 -o asterisk -g root
	keepdir /var/lib/asterisk
	keepdir /var/spool/asterisk
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail,recording}
	diropts -m 0750 -o asterisk -g asterisk
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	newinitd "${FILESDIR}"/initd-13.32.0-r1 asterisk
	newconfd "${FILESDIR}"/confd-13.32.0 asterisk

	systemd_dounit "${FILESDIR}"/asterisk.service
	newtmpfiles "${FILESDIR}"/asterisk.tmpfiles2.conf asterisk.conf
	systemd_install_serviced "${FILESDIR}"/asterisk.service.conf

	# Reset diropts else dodoc uses it for doc installations.
	diropts -m0755

	# install the upgrade documentation
	dodoc UPGRADE* BUGS CREDITS

	# install extra documentation
	use doc &&doc/*.{txt,pdf}

	# install logrotate snippet; bug #329281
	#
	insinto /etc/logrotate.d
	newins "${FILESDIR}/1.6.2/asterisk.logrotate4" asterisk

	# Asterisk installs a few folders that's empty by design,
	# but still required.  This finds them, and marks them for
	# portage.
	while read d < <(find "${ED}"/var -type d -empty || die "Find failed."); do
		keepdir "${d#${ED}}"
	done
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ]; then
		elog "Asterisk Wiki: https://wiki.asterisk.org/wiki/"
		elog "Gentoo VoIP IRC Channel: #gentoo-voip @ irc.freenode.net"
	elif [ "$(ver_cut 1 "${REPLACING_VERSIONS}")" != "$(ver_cut 1)" ]; then
		elog "You are updating from Asterisk $(ver_cut 1 "${REPLACING_VERSIONS}") upgrade document:"
		elog "https://wiki.asterisk.org/wiki/display/AST/Upgrading+to+Asterisk+$(ver_cut 1)"
		elog "Gentoo VoIP IRC Channel: #gentoo-voip @ irc.freenode.net"
	fi
}
