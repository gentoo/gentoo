# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )

inherit autotools linux-info lua-single toolchain-funcs

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="https://www.asterisk.org/"
SRC_URI="https://downloads.asterisk.org/pub/telephony/asterisk/releases/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0/${PV%%.*}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

IUSE_VOICEMAIL_STORAGE=(
	voicemail_storage_odbc
	voicemail_storage_imap
)
IUSE="${IUSE_VOICEMAIL_STORAGE[*]} blocks bluetooth calendar +caps cluster codec2 curl debug doc freetds gtalk http iconv ilbc ldap lua mysql newt odbc pjproject portaudio postgres radius selinux snmp span speex srtp +ssl static statsd systemd unbound vorbis xmpp"
IUSE_EXPAND="VOICEMAIL_STORAGE"
REQUIRED_USE="gtalk? ( xmpp )
	lua? ( ${LUA_REQUIRED_USE} )
	voicemail_storage_odbc? ( odbc )
"

PATCHES=(
	"${FILESDIR}/asterisk-16.16.2-no-var-run-install.patch"
)

DEPEND="acct-user/asterisk
	acct-group/asterisk
	dev-db/sqlite:3
	dev-libs/popt
	>=dev-libs/jansson-2.11:=
	dev-libs/libedit
	dev-libs/libxml2:2
	dev-libs/libxslt
	sys-apps/util-linux
	sys-libs/zlib
	virtual/libcrypt:=
	bluetooth? ( net-wireless/bluez:= )
	calendar? (
		net-libs/neon:=
		dev-libs/libical:=
		dev-libs/iksemel
	)
	caps? ( sys-libs/libcap )
	blocks? ( sys-libs/blocksruntime )
	cluster? ( sys-cluster/corosync )
	codec2? ( media-libs/codec2:= )
	curl? ( net-misc/curl )
	freetds? ( dev-db/freetds )
	gtalk? ( dev-libs/iksemel )
	http? ( dev-libs/gmime:2.6 )
	iconv? ( virtual/libiconv )
	ilbc? ( media-libs/libilbc )
	ldap? ( net-nds/openldap:= )
	lua? ( ${LUA_DEPS} )
	mysql? ( dev-db/mysql-connector-c:= )
	newt? ( dev-libs/newt )
	odbc? ( dev-db/unixODBC )
	pjproject? ( >=net-libs/pjproject-2.12:= )
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
	srtp? ( net-libs/libsrtp:= )
	ssl? (
		dev-libs/openssl:0=
	)
	systemd? ( sys-apps/systemd )
	!systemd? ( !sys-apps/systemd )
	unbound? ( net-dns/unbound )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	voicemail_storage_imap? ( net-libs/c-client[ssl=] )
	xmpp? ( dev-libs/iksemel )
"

RDEPEND="${DEPEND}
	net-misc/asterisk-core-sounds
	net-misc/asterisk-extra-sounds
	net-misc/asterisk-moh-opsound
	selinux? ( sec-policy/selinux-asterisk )"
PDEPEND="net-misc/asterisk-base"

BDEPEND="dev-libs/libxml2:2
	virtual/pkgconfig"

QA_CONFIG_IMPL_DECL_SKIP=(
	htonll
	ntohll
)
QA_DT_NEEDED="/usr/lib.*/libasteriskssl[.]so[.][0-9]\+"

ast_make() {
	local make_args=(
		"NOISY_BUILD=yes"
		"ASTDBDIR=\$(ASTDATADIR)/astdb"
		"ASTVARRUNDIR=/run/asterisk"
		"ASTCACHEDIR=/var/cache/asterisk"
		"OPTIMIZE="
		"DEBUG="
		"CONFIG_SRC=configs/samples"
		"CONFIG_EXTEN=.sample"
		"AST_FORTIFY_SOURCE="
	)

	emake "${make_args[@]}" "$@"
}

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
	AT_M4DIR="autoconf third-party third-party/pjproject third-party/jansson third-party/libjwt" \
		AC_CONFIG_SUBDIRS=menuselect eautoreconf
}

src_configure() {
	local vmst
	local copt cstate
	local myconf=(
		LUA_VERSION="${ELUA#lua}" \
		--localstatedir="/var" \
		--with-crypto \
		--with-gsm=internal \
		--with-popt \
		--with-z \
		--with-libedit \
		--without-jansson-bundled \
		--without-pjproject-bundled \
		$(use_with caps cap) \
		$(use_with codec2) \
		$(use_with lua lua) \
		$(use_with http gmime) \
		$(use_with newt) \
		$(use_with pjproject) \
		$(use_with portaudio) \
		$(use_with ssl) \
		$(use_with unbound)
	)

	econf "${myconf[@]}"

	ast_menuselect() {
		menuselect/menuselect "$@" menuselect.makeopts || die "menuselect $* failed."
	}

	_use_select() {
		local state=$(use "$1" && echo enable || echo disable)
		local x
		shift # remove use from parameters

		for x; do
			ast_menuselect --${state} "$x"
		done
	}

	# Blank out sounds/sounds.xml file to prevent
	# asterisk from installing sounds files (we pull them in via
	# asterisk-{core,extra}-sounds and asterisk-moh-opsound.
	>sounds/sounds.xml || die "Unable to blank out sounds/sounds.xml"

	# That NATIVE_ARCH chatter really is quite bothersome
	sed -i 's/NATIVE_ARCH=/&0/' build_tools/menuselect-deps || die "Unable to squelch noisy build system"

	# Compile menuselect binary for optional components
	ast_make menuselect.makeopts

	# Disable astdb2* tools.  We've been on sqlite long enough
	# that this should really no longer be a problem (bug #https://bugs.gentoo.org/872194)
	ast_menuselect --disable astdb2sqlite3
	ast_menuselect --disable astdb2bdb

	# Disable BUILD_NATIVE (bug #667498)
	ast_menuselect --disable build_native

	# Broken functionality is forcibly disabled (bug #360143)
	ast_menuselect --disable chan_ooh323

	# Utility set is forcibly enabled (bug #358001)
	ast_menuselect --enable smsq
	ast_menuselect --enable streamplayer
	ast_menuselect --enable aelparse
	ast_menuselect --enable astman

	# SSL is forcibly enabled, IAX2 & DUNDI are expected to be available
	ast_menuselect --enable pbx_dundi
	ast_menuselect --enable func_aes
	ast_menuselect --enable chan_iax2

	# SQlite3 is now the main database backend, enable related features
	ast_menuselect --enable cdr_sqlite3_custom
	ast_menuselect --enable cel_sqlite3_custom

	# Disable conversion tools (which fails to compile in some cases).
	ast_menuselect --disable astdb2bdb

	# The others are based on USE-flag settings
	_use_select bluetooth    chan_mobile
	_use_select calendar     res_calendar res_calendar_{caldav,ews,exchange,icalendar}
	_use_select cluster      res_corosync
	_use_select codec2       codec_codec2
	_use_select curl         func_curl res_config_curl res_curl
	_use_select freetds      {cdr,cel}_tds
	_use_select gtalk        chan_motif
	_use_select http         res_http_post
	_use_select iconv        func_iconv
	_use_select ilbc         codec_ilbc format_ilbc
	_use_select ldap         res_config_ldap
	_use_select lua          pbx_lua
	_use_select mysql        res_config_mysql
	_use_select odbc         cdr_adaptive_odbc res_config_odbc {cdr,cel,res,func}_odbc
	_use_select postgres     {cdr,cel}_pgsql res_config_pgsql
	_use_select radius       {cdr,cel}_radius
	_use_select snmp         res_snmp
	_use_select span         res_fax_spandsp
	_use_select speex        {codec,func}_speex
	_use_select speex        format_ogg_speex
	_use_select srtp         res_srtp
	_use_select statsd       res_statsd res_{endpoint,chan}_stats
	_use_select vorbis       format_ogg_vorbis
	_use_select xmpp         res_xmpp

	# Voicemail storage ...
	ast_menuselect --enable app_voicemail
	for vmst in "${IUSE_VOICEMAIL_STORAGE[@]}"; do
		if use "${vmst#+}"; then
			ast_menuselect --enable "app_voicemail_${vmst##*_}"
		fi
	done

	if use debug; then
		for o in DONT_OPTIMIZE DEBUG_FD_LEAKS MALLOC_DEBUG BETTER_BACKTRACES; do
			ast_menuselect --enable "${o}"
		done
	fi

	if [[ -n "${GENTOO_ASTERISK_CUSTOM_MENUSELECT:+yes}" ]]; then
		for copt in ${GENTOO_ASTERISK_CUSTOM_MENUSELECT}; do
			cstate=--enable
			[[ "${copt}" == -* ]] && cstate=--disable
			ebegin "Custom option ${copt#[-+]} ${cstate:2}d"
			ast_menuselect ${cstate} "${copt#[-+]}"
			eend $?
		done
	fi
}

src_compile() {
	ast_make
}

src_install() {
	local d

	dodir "/usr/$(get_libdir)/pkgconfig"

	diropts -m 0750 -o root -g asterisk
	dodir /etc/asterisk

	ast_make install install-headers install-configs "DESTDIR=${D}"

	fowners asterisk: /var/lib/asterisk/astdb

	if use radius; then
		insinto /etc/radiusclient/
		doins contrib/dictionary.digium
	fi

	# keep directories
	diropts -m 0750 -o asterisk -g root
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail,recording,outgoing}
	diropts -m 0750 -o asterisk -g asterisk
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	# Reset diropts else dodoc uses it for doc installations.
	diropts -m0755

	dodoc README* BUGS CREDITS

	# install extra documentation
	use doc && dodoc doc/*.{txt,pdf}

	# Asterisk installs a few folders that's empty by design,
	# but still required.  This finds them, and marks them for
	# portage.
	while read d <&3; do
		keepdir "${d#${ED}}"
	done 3< <(find "${ED}"/var -type d -empty || die "Find failed.")
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Asterisk Wiki: https://wiki.asterisk.org/wiki/"
		elog "Gentoo VoIP IRC Channel: #gentoo-voip @ irc.libera.chat"
	else
		local my_replacing=() x
		for x in ${REPLACING_VERSIONS}; do
			[[ $(ver_cut 1 ${x}) != $(ver_cut 1) ]] &&
				my_replacing+=( $(ver_cut 1 ${x}) )
		done
		if [[ "${#my_replacing}" -gt 0 ]]; then
			my_replacing="${my_replacing[*]}"
			my_replacing="${my_replacing// /, }"
			[[ "${my_replacing}" = *", "* ]] &&
				my_replacing="${my_replacing%, *} or ${my_replacing##*, }"
			elog "You are updating from Asterisk ${my_replacing}, you should reference the upgrade document:"
			elog "https://wiki.asterisk.org/wiki/display/AST/Upgrading+to+Asterisk+$(ver_cut 1)"
			elog "Assistance also available on Gentoo VoIP IRC Channel: #gentoo-voip @ irc.libera.chat"
		fi
	fi

	if [[ -n "${GENTOO_ASTERISK_CUSTOM_MENUSELECT:+yes}" ]]; then
		ewarn "You are using GENTOO_ASTERISK_CUSTOM_MENUSELECT, this should only be used"
		ewarn "for debugging, for anything else, please file a bug on https://bugs.gentoo.org"
	fi

	if [[ -f /var/lib/asterisk/astdb.sqlite3 ]]; then
		ewarn "Default astdb location has changed from /var/lib/asterisk to /var/lib/asterisk/astdb"
		ewarn "You still have a /var/lib/asterisk/astdb.sqlite file.  You need to either set"
		ewarn "astdbdir in /etc/asterisk/asterisk.conf to /var/lib/asterisk or follow these"
		ewarn "steps to migrate:"
		ewarn "1.  /etc/init.d/asterisk stop"
		ewarn "2.  mv /var/lib/asterisk/astdb.sqlite /var/lib/asterisk/astdb/"
		ewarn "3.  /etc/init.d/asterisk start"
		ewarn "This update was done partly for security reasons so that /var/lib/asterisk can be root owned."
	fi
}
