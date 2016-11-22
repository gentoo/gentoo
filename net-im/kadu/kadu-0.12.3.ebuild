# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit cmake-utils flag-o-matic

MY_P="${P/_/-}"

DESCRIPTION="An open source Gadu-Gadu and Jabber/XMPP protocol Instant Messenger client"
HOMEPAGE="http://www.kadu.net"
SRC_URI="http://download.kadu.im/stable/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE="ayatana +gadu mpd phonon sdk speech spell xmpp"
REQUIRED_USE="
	|| (
		gadu
		xmpp
	)
"
COMMON_DEPEND="
	app-crypt/qca:2[qt4(+)]
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXScrnSaver
	>=dev-qt/qtdbus-4.7.0:4
	>=dev-qt/qtgui-4.7.0:4
	>=dev-qt/qtscript-4.7.0:4
	>=dev-qt/qtsql-4.7.0:4[sqlite]
	>=dev-qt/qtwebkit-4.7.0:4
	ayatana? ( dev-libs/libindicate-qt )
	gadu? (
		>=net-libs/libgadu-1.11.1[threads]
		>=dev-qt/qtxmlpatterns-4.7.0:4
	)
	mpd? ( media-libs/libmpdclient )
	phonon? (
		|| (
			media-libs/phonon[qt4]
			>=dev-qt/qtphonon-4.7.0:4
		)
	)
	spell? ( app-text/enchant )
	xmpp? (
		net-dns/libidn
		sys-libs/zlib
	)
"
DEPEND="${COMMON_DEPEND}
	x11-proto/fixesproto
	x11-proto/scrnsaverproto
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca:2[ssl]
	>=dev-qt/qtsvg-4.7.0:4
	speech? ( app-accessibility/powiedz )
"

PLUGINS='amarok1_mediaplayer antistring auto_hide autoaway autoresponder autostatus cenzor chat_notify config_wizard desktop_docking docking encryption_ng encryption_ng_simlite exec_notify ext_sound falf_mediaplayer filedesc firewall freedesktop_notify hints history idle imagelink last_seen mediaplayer mprisplayer_mediaplayer pcspeaker qt4_docking qt4_docking_notify screenshot simpleview single_window sms sound sql_history tabs word_fix'

src_configure() {
	# Filter out dangerous flags
	filter-flags -fno-rtti
	strip-unsupported-flags

	# Ensure -DQT_NO_DEBUG is added
	append-cppflags -DQT_NO_DEBUG

	# Plugin selection
	if use gadu; then
		PLUGINS+=' gadu_protocol history_migration profiles_import'
	fi

	use mpd && PLUGINS+=' mpd_mediaplayer'
	use xmpp && PLUGINS+=' jabber_protocol'
	use phonon && PLUGINS+=' phonon_sound'
	use speech && PLUGINS+=' speech'
	use spell && PLUGINS+=' spellchecker'

	# Configure package
	local mycmakeargs=(
		-DBUILD_DESCRIPTION='Gentoo Linux'
		-DCOMPILE_PLUGINS="${PLUGINS}"
		-DNETWORK_IMPLEMENTATION="Qt"
		-DSIG_HANDLING_ENABLED=TRUE
		$(cmake-utils_use sdk INSTALL_SDK)
		$(cmake-utils_use_with ayatana INDICATE_QT)
		$(cmake-utils_use_with spell ENCHANT)
	)
	unset PLUGINS

	cmake-utils_src_configure
}
