# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils linux-info multilib user systemd

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/asterisk/releases/${MY_P}.tar.gz
	 mirror://gentoo/gentoo-asterisk-patchset-4.07.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE_VOICEMAIL_STORAGE="
	+voicemail_storage_file
	voicemail_storage_odbc
	voicemail_storage_imap
"
IUSE="${IUSE_VOICEMAIL_STORAGE} alsa bluetooth calendar +caps cluster curl dahdi debug doc freetds gtalk http iconv ilbc xmpp ldap libedit libressl lua mysql newt +samples odbc osplookup oss pjproject portaudio postgres radius selinux snmp span speex srtp static syslog vorbis"
IUSE_EXPAND="VOICEMAIL_STORAGE"
REQUIRED_USE="gtalk? ( xmpp )
	^^ ( ${IUSE_VOICEMAIL_STORAGE/+/} )
	voicemail_storage_odbc? ( odbc )
"

EPATCH_SUFFIX="patch"
PATCHES=( "${WORKDIR}/asterisk-patchset" )

CDEPEND="dev-db/sqlite:3
	dev-libs/popt
	dev-libs/jansson
	dev-libs/libxml2
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	sys-libs/ncurses:*
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	calendar? ( net-libs/neon
		 dev-libs/libical
		 dev-libs/iksemel )
	caps? ( sys-libs/libcap )
	cluster? ( sys-cluster/corosync )
	curl? ( net-misc/curl )
	dahdi? ( >=net-libs/libpri-1.4.12_beta2
		net-misc/dahdi-tools )
	freetds? ( dev-db/freetds )
	gtalk? ( dev-libs/iksemel )
	http? ( dev-libs/gmime:2.6 )
	iconv? ( virtual/libiconv )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	xmpp? ( dev-libs/iksemel )
	ldap? ( net-nds/openldap )
	libedit? ( dev-libs/libedit )
	lua? ( dev-lang/lua:* )
	mysql? ( virtual/mysql )
	newt? ( dev-libs/newt )
	odbc? ( dev-db/unixODBC )
	osplookup? ( net-libs/osptoolkit )
	portaudio? ( media-libs/portaudio )
	postgres? ( dev-db/postgresql:* )
	radius? ( net-dialup/freeradius-client )
	snmp? ( net-analyzer/net-snmp )
	span? ( media-libs/spandsp )
	speex? ( media-libs/speex )
	srtp? ( net-libs/libsrtp:0 )
	vorbis? ( media-libs/libvorbis )"

DEPEND="${CDEPEND}
	!net-libs/openh323
	!net-libs/pjsip
	voicemail_storage_imap? ( virtual/imap-c-client )
	virtual/pkgconfig
	pjproject? ( >=net-libs/pjproject-2.6 )
"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-asterisk )
	syslog? ( virtual/logger )"

PDEPEND="net-misc/asterisk-core-sounds
	net-misc/asterisk-extra-sounds
	net-misc/asterisk-moh-opsound"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	CONFIG_CHECK="~!NF_CONNTRACK_SIP"
	local WARNING_NF_CONNTRACK_SIP="SIP (NAT) connection tracking is enabled. Some users
	have reported that this module dropped critical SIP packets in their deployments. You
	may want to disable it if you see such problems."
	check_extra_config

	enewgroup asterisk
	enewgroup dialout 20
	enewuser asterisk -1 -1 /var/lib/asterisk "asterisk,dialout"
}

src_prepare() {
	default
	AT_M4DIR="autoconf third-party third-party/pjproject" eautoreconf
}

src_configure() {
	local vmst

	econf \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-crypto \
		--with-gsm=internal \
		--with-popt \
		--with-ssl \
		--with-z \
		--without-pwlib \
		$(use_with caps cap) \
		$(use_with http gmime) \
		$(use_with newt) \
		$(use_with portaudio) \
		$(use_with pjproject)

	# Blank out sounds/sounds.xml file to prevent
	# asterisk from installing sounds files (we pull them in via
	# asterisk-{core,extra}-sounds and asterisk-moh-opsound.
	>"${S}"/sounds/sounds.xml

	# That NATIVE_ARCH chatter really is quite bothersome
	sed -i 's/NATIVE_ARCH=/NATIVE_ARCH=0/' build_tools/menuselect-deps || die "Unable to squelch noisy build system"

	# Compile menuselect binary for optional components
	emake menuselect.makeopts

	# We'll decide our target CPU in make.conf
	menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts

	# Broken functionality is forcibly disabled (bug #360143)
	menuselect/menuselect --disable chan_misdn menuselect.makeopts
	menuselect/menuselect --disable chan_ooh323 menuselect.makeopts

	# Utility set is forcibly enabled (bug #358001)
	menuselect/menuselect --enable smsq menuselect.makeopts
	menuselect/menuselect --enable streamplayer menuselect.makeopts
	menuselect/menuselect --enable aelparse menuselect.makeopts
	menuselect/menuselect --enable astman menuselect.makeopts

	# this is connected, otherwise it would not find
	# ast_pktccops_gate_alloc symbol
	menuselect/menuselect --enable chan_mgcp menuselect.makeopts
	menuselect/menuselect --enable res_pktccops menuselect.makeopts

	# SSL is forcibly enabled, IAX2 & DUNDI are expected to be available
	menuselect/menuselect --enable pbx_dundi menuselect.makeopts
	menuselect/menuselect --enable func_aes menuselect.makeopts
	menuselect/menuselect --enable chan_iax2 menuselect.makeopts

	# SQlite3 is now the main database backend, enable related features
	menuselect/menuselect --enable cdr_sqlite3_custom menuselect.makeopts
	menuselect/menuselect --enable cel_sqlite3_custom menuselect.makeopts

	# The others are based on USE-flag settings
	use_select() {
		local state=$(use "$1" && echo enable || echo disable)
		shift # remove use from parameters

		while [[ -n $1 ]]; do
			menuselect/menuselect --${state} "$1" menuselect.makeopts
			shift
		done
	}

	use_select alsa			chan_alsa
	use_select bluetooth		chan_mobile
	use_select calendar		res_calendar res_calendar_{caldav,ews,exchange,icalendar}
	use_select cluster		res_corosync
	use_select curl			func_curl res_config_curl res_curl
	use_select dahdi		app_dahdiras app_meetme chan_dahdi codec_dahdi res_timing_dahdi
	use_select freetds		{cdr,cel}_tds
	use_select gtalk		chan_motif
	use_select http			res_http_post
	use_select iconv		func_iconv
	use_select xmpp			res_xmpp
	use_select ilbc                 codec_ilbc format_ilbc
	use_select ldap			res_config_ldap
	use_select lua			pbx_lua
	use_select mysql		app_mysql cdr_mysql res_config_mysql
	use_select odbc			cdr_adaptive_odbc res_config_odbc {cdr,cel,res,func}_odbc
	use_select osplookup		app_osplookup
	use_select oss			chan_oss
	use_select postgres		{cdr,cel}_pgsql res_config_pgsql
	use_select radius		{cdr,cel}_radius
	use_select snmp			res_snmp
	use_select span			res_fax_spandsp
	use_select speex		{codec,func}_speex
	use_select srtp			res_srtp
	use_select syslog		cdr_syslog
	use_select vorbis		format_ogg_vorbis

	# Voicemail storage ...
	for vmst in ${IUSE_VOICEMAIL_STORAGE/+/}; do
		if use ${vmst}; then
			menuselect/menuselect --enable $(echo ${vmst##*_} | tr '[:lower:]' '[:upper:]')_STORAGE menuselect.makeopts
		fi
	done

	if use debug; then
		for o in DONT_OPTIMIZE DEBUG_THREADS BETTER_BACKTRACES; do
			menuselect/menuselect --enable $o menuselect.makeopts
		done
	fi
}

src_compile() {
	ASTLDFLAGS="${LDFLAGS}" emake
}

src_install() {
	mkdir -p "${D}"usr/$(get_libdir)/pkgconfig || die
	emake DESTDIR="${D}" installdirs
	emake DESTDIR="${D}" install

	if use radius; then
		insinto /etc/radiusclient/
		doins contrib/dictionary.digium
	fi
	diropts -m 0750 -o root -g asterisk
	keepdir	/etc/asterisk
	if use samples; then
		emake DESTDIR="${D}" samples
		for conffile in "${D}"etc/asterisk/*.*
		do
			chown root:root $conffile
			chmod 0644 $conffile
		done
		einfo "Sample files have been installed"
	else
		einfo "Skipping installation of sample files..."
		rm -f  "${D}"var/lib/asterisk/mohmp3/* || die
		rm -f  "${D}"var/lib/asterisk/sounds/demo-* || die
		rm -f  "${D}"var/lib/asterisk/agi-bin/* || die
		rm -f  "${D}"etc/asterisk/* || die
	fi
	rm -rf "${D}"var/spool/asterisk/voicemail/default || die

	# keep directories
	diropts -m 0770 -o asterisk asterisk
	keepdir /var/lib/asterisk
	keepdir /var/spool/asterisk
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail}
	diropts -m 0750 -o asterisk -g asterisk
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	newinitd "${FILESDIR}"/1.8.0/asterisk.initd8 asterisk
	newconfd "${FILESDIR}"/1.8.0/asterisk.confd asterisk

	systemd_dounit "${FILESDIR}"/asterisk.service
	systemd_newtmpfilesd "${FILESDIR}"/asterisk.tmpfiles.conf asterisk.conf
	systemd_install_serviced "${FILESDIR}"/asterisk.service.conf

	# install the upgrade documentation
	#
	dodoc UPGRADE* BUGS CREDITS

	# install extra documentation
	#
	if use doc
	then
		dodoc doc/*.txt
		dodoc doc/*.pdf
	fi

	# install SIP scripts; bug #300832
	#
	dodoc "${FILESDIR}/1.6.2/sip_calc_auth"
	dodoc "${FILESDIR}/1.8.0/find_call_sip_trace.sh"
	dodoc "${FILESDIR}/1.8.0/find_call_ids.sh"
	dodoc "${FILESDIR}/1.6.2/call_data.txt"

	# install logrotate snippet; bug #329281
	#
	insinto /etc/logrotate.d
	newins "${FILESDIR}/1.6.2/asterisk.logrotate4" asterisk
}

pkg_postinst() {
	#
	# Announcements, warnings, reminders...
	#
	einfo "Asterisk has been installed"
	echo
	elog "If you want to know more about asterisk, visit these sites:"
	elog "http://www.asteriskdocs.org/"
	elog "http://www.voip-info.org/wiki-Asterisk"
	echo
	elog "http://www.automated.it/guidetoasterisk.htm"
	echo
	elog "Gentoo VoIP IRC Channel:"
	elog "#gentoo-voip @ irc.freenode.net"
	echo
	echo
	elog "Please read the Asterisk 13 upgrade document:"
	elog "https://wiki.asterisk.org/wiki/display/AST/Upgrading+to+Asterisk+13"
}

pkg_config() {
	einfo "Do you want to reset file permissions and ownerships (y/N)?"

	read tmp
	tmp="$(echo $tmp | tr '[:upper:]' '[:lower:]')"

	if [[ "$tmp" = "y" ]] ||\
		[[ "$tmp" = "yes" ]]
	then
		einfo "Resetting permissions to defaults..."

		for x in spool run lib log; do
			chown -R asterisk:asterisk "${ROOT}"var/${x}/asterisk
			chmod -R u=rwX,g=rwX,o=    "${ROOT}"var/${x}/asterisk
		done

		chown -R root:asterisk  "${ROOT}"etc/asterisk
		chmod -R u=rwX,g=rwX,o= "${ROOT}"etc/asterisk

		einfo "done"
	else
		einfo "skipping"
	fi
}
