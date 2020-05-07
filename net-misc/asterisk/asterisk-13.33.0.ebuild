# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info systemd

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="https://www.asterisk.org/"
SRC_URI="https://downloads.asterisk.org/pub/telephony/asterisk/releases/${P}.tar.gz
	https://downloads.uls.co.za/gentoo/asterisk/gentoo-asterisk-patchset-4.08.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"

IUSE_VOICEMAIL_STORAGE="
	+voicemail_storage_file
	voicemail_storage_odbc
	voicemail_storage_imap
"
IUSE="${IUSE_VOICEMAIL_STORAGE} alsa bluetooth calendar +caps cluster curl dahdi debug doc freetds gtalk http iconv ilbc ldap libedit libressl lua mysql newt odbc osplookup oss pjproject portaudio postgres radius selinux snmp span speex srtp +ssl static statsd syslog vorbis xmpp"
IUSE_EXPAND="VOICEMAIL_STORAGE"
REQUIRED_USE="gtalk? ( xmpp )
	^^ ( ${IUSE_VOICEMAIL_STORAGE/+/} )
	voicemail_storage_odbc? ( odbc )
"

PATCHES=(
	"${FILESDIR}/asterisk-historic-no-var-run-install.patch"
)

DEPEND="acct-user/asterisk
	acct-group/asterisk
	dev-db/sqlite:3
	dev-libs/popt
	dev-libs/jansson
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
	libedit? ( dev-libs/libedit )
	lua? ( dev-lang/lua:* )
	mysql? ( dev-db/mysql-connector-c:= )
	newt? ( dev-libs/newt )
	odbc? ( dev-db/unixODBC )
	osplookup? ( net-libs/osptoolkit )
	pjproject? ( net-libs/pjproject )
	portaudio? ( media-libs/portaudio )
	postgres? ( dev-db/postgresql:* )
	radius? ( net-dialup/freeradius-client )
	snmp? ( net-analyzer/net-snmp:= )
	span? ( media-libs/spandsp )
	speex? (
		media-libs/speex
		media-libs/speexdsp
	)
	srtp? ( net-libs/libsrtp:0 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	vorbis? ( media-libs/libvorbis )
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

pkg_setup() {
	CONFIG_CHECK="~!NF_CONNTRACK_SIP"
	local WARNING_NF_CONNTRACK_SIP="SIP (NAT) connection tracking is enabled. Some users
	have reported that this module dropped critical SIP packets in their deployments. You
	may want to disable it if you see such problems."
	check_extra_config
}

src_prepare() {
	default
	AT_M4DIR="autoconf third-party third-party/pjproject third-party/jansson" eautoreconf
}

function menuselect() {
	menuselect/menuselect "$@" || die "menuselect $* failed."
}

src_configure() {
	local vmst

	econf \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-crypto \
		--with-gsm=internal \
		--with-popt \
		--with-z \
		--without-libedit \
		$(use_with caps cap) \
		$(use_with http gmime) \
		$(use_with newt) \
		$(use_with pjproject) \
		$(use_with portaudio) \
		$(use_with ssl)

	# Blank out sounds/sounds.xml file to prevent
	# asterisk from installing sounds files (we pull them in via
	# asterisk-{core,extra}-sounds and asterisk-moh-opsound.
	>"${S}"/sounds/sounds.xml

	# That NATIVE_ARCH chatter really is quite bothersome
	sed -i 's/NATIVE_ARCH=/NATIVE_ARCH=0/' build_tools/menuselect-deps || die "Unable to squelch noisy build system"

	# Compile menuselect binary for optional components
	emake NOISE_BUILD=yes menuselect.makeopts

	# Disable BUILD_NATIVE (bug #667498)
	menuselect --disable build_native menuselect.makeopts

	# Broken functionality is forcibly disabled (bug #360143)
	menuselect --disable chan_misdn menuselect.makeopts
	menuselect --disable chan_ooh323 menuselect.makeopts

	# Utility set is forcibly enabled (bug #358001)
	menuselect --enable smsq menuselect.makeopts
	menuselect --enable streamplayer menuselect.makeopts
	menuselect --enable aelparse menuselect.makeopts
	menuselect --enable astman menuselect.makeopts

	# this is connected, otherwise it would not find
	# ast_pktccops_gate_alloc symbol
	menuselect --enable chan_mgcp menuselect.makeopts
	menuselect --enable res_pktccops menuselect.makeopts

	# SSL is forcibly enabled, IAX2 & DUNDI are expected to be available
	menuselect --enable pbx_dundi menuselect.makeopts
	menuselect --enable func_aes menuselect.makeopts
	menuselect --enable chan_iax2 menuselect.makeopts

	# SQlite3 is now the main database backend, enable related features
	menuselect --enable cdr_sqlite3_custom menuselect.makeopts
	menuselect --enable cel_sqlite3_custom menuselect.makeopts

	# The others are based on USE-flag settings
	use_select() {
		local state=$(use "$1" && echo enable || echo disable)
		shift # remove use from parameters

		while [[ -n $1 ]]; do
			menuselect --${state} "$1" menuselect.makeopts
			shift
		done
	}

	use_select alsa         chan_alsa
	use_select bluetooth    chan_mobile
	use_select calendar     res_calendar res_calendar_{caldav,ews,exchange,icalendar}
	use_select cluster      res_corosync
	use_select curl         func_curl res_config_curl res_curl
	use_select dahdi        app_dahdiras app_meetme chan_dahdi codec_dahdi res_timing_dahdi
	use_select freetds      {cdr,cel}_tds
	use_select gtalk        chan_motif
	use_select http         res_http_post
	use_select iconv        func_iconv
	use_select ilbc         codec_ilbc format_ilbc
	use_select ldap         res_config_ldap
	use_select lua          pbx_lua
	use_select mysql        app_mysql cdr_mysql res_config_mysql
	use_select odbc         cdr_adaptive_odbc res_config_odbc {cdr,cel,res,func}_odbc
	use_select osplookup    app_osplookup
	use_select oss          chan_oss
	use_select postgres     {cdr,cel}_pgsql res_config_pgsql
	use_select radius       {cdr,cel}_radius
	use_select snmp         res_snmp
	use_select span         res_fax_spandsp
	use_select speex        {codec,func}_speex
	use_select srtp         res_srtp
	use_select statsd       res_statsd res_{endpoint,chan}_stats
	use_select syslog       cdr_syslog
	use_select vorbis       format_ogg_vorbis
	use_select xmpp         res_xmpp

	# Voicemail storage ...
	for vmst in ${IUSE_VOICEMAIL_STORAGE/+/}; do
		if use ${vmst}; then
			menuselect --enable $(echo ${vmst##*_} | tr '[:lower:]' '[:upper:]')_STORAGE menuselect.makeopts
		fi
	done

	if use debug; then
		for o in DONT_OPTIMIZE DEBUG_THREADS BETTER_BACKTRACES; do
			menuselect --enable $o menuselect.makeopts
		done
	fi
}

src_compile() {
	emake ASTCFLAGS="${CFLAGS}" ASTLDFLAGS="${LDFLAGS}" NOISY_BUILD=yes
}

src_install() {
	local d

	mkdir -p "${ED}/usr/$(get_libdir)/pkgconfig" || die
	emake DESTDIR="${ED}" NOISY_BUILD=yes install

	if use radius; then
		insinto /etc/radiusclient/
		doins contrib/dictionary.digium
	fi
	diropts -m 0750 -o root -g asterisk
	keepdir	/etc/asterisk
	emake NOISY_BUILD=yes DESTDIR="${ED}" CONFIG_SRC=configs/samples CONFIG_EXTEN=.sample install-configs
	for conffile in "${ED}/etc/asterisk/"*
	do
		fowners root:root "${conffile#${ED}}"
		fperms 0644 "${conffile#${ED}}"
	done

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
	systemd_newtmpfilesd "${FILESDIR}"/asterisk.tmpfiles.conf asterisk.conf
	systemd_install_serviced "${FILESDIR}"/asterisk.service.conf

	# Reset diropts else dodoc uses it for doc installations.
	diropts -m0755

	# install the upgrade documentation
	dodoc UPGRADE* BUGS CREDITS

	# install extra documentation
	if use doc; then
		dodoc doc/*.txt
		dodoc doc/*.pdf
	fi

	# install logrotate snippet; bug #329281
	#
	insinto /etc/logrotate.d
	newins "${FILESDIR}/1.6.2/asterisk.logrotate4" asterisk

	# Asterisk installs a few folders that's empty by design,
	# but still required.  This finds them, and marks them for
	# portage.
	for d in $(find "${ED}"/var -type d -empty || die "Find failed."); do
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
