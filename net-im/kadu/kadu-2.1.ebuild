# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kadu/kadu-2.1.ebuild,v 1.2 2015/07/05 20:25:47 reavertm Exp $

EAPI="5"

inherit base cmake-utils flag-o-matic

MY_P="${P/_/-}"

DESCRIPTION="An open source Gadu-Gadu and Jabber/XMPP protocol Instant Messenger client"
HOMEPAGE="http://www.kadu.net"
SRC_URI="http://download.kadu.im/stable/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+gadu mpd otr phonon sdk speech spell xmpp"
REQUIRED_USE="
	|| (
		gadu
		xmpp
	)
"
COMMON_DEPEND="
	app-crypt/qca:2[openssl,qt5]
	>=dev-libs/injeqt-1.0.0
	>=dev-qt/qtcore-5.2.0:5
	>=dev-qt/qtdbus-5.2.0:5
	>=dev-qt/qtgui-5.2.0:5
	>=dev-qt/qtmultimedia-5.2.0:5
	>=dev-qt/qtnetwork-5.2.0:5
	>=dev-qt/qtquick1-5.2.0:5
	>=dev-qt/qtscript-5.2.0:5
	>=dev-qt/qtsql-5.2.0:5
	>=dev-qt/qtsvg-5.2.0:5
	>=dev-qt/qtwebkit-5.2.0:5
	>=dev-qt/qtwidgets-5.2.0:5
	>=dev-qt/qtx11extras-5.2.0:5
	>=dev-qt/qtxml-5.2.0:5
	>=dev-qt/qtxmlpatterns-5.2.0:5
	>=app-arch/libarchive-2.6[lzma]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXScrnSaver
	gadu? ( >=net-libs/libgadu-1.11.1[threads] )
	mpd? ( media-libs/libmpdclient )
	otr? (
		>=dev-libs/libgcrypt-1.2.2:0
		>=net-libs/libotr-4.1.0
	)
	phonon? (
		|| (
			media-libs/phonon[qt5]
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
	>=dev-qt/linguist-tools-5.2.0:5
	x11-proto/scrnsaverproto
	x11-proto/xextproto
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	speech? ( app-accessibility/powiedz )
"

PATCHES=(
	"${FILESDIR}/${P}-qt5-compilation.patch"
)

PLUGINS='
antistring
auto_hide
autoaway
autoresponder
autostatus
cenzor
chat_notify
config_wizard
desktop_docking
docking
emoticons
encryption_ng
encryption_ng_simlite
exec_notify
ext_sound
falf_mediaplayer
filedesc
firewall
freedesktop_notify
hints
history
idle
imagelink
last_seen
mediaplayer
mprisplayer_mediaplayer
pcspeaker
qt4_docking
qt4_docking_notify
screenshot simpleview
single_window
sms
sound
sql_history
tabs
word_fix
'

src_configure() {
	# Filter out dangerous flags
	filter-flags -fno-rtti
	strip-unsupported-flags

	# Ensure -DQT_NO_DEBUG is added
	append-cppflags -DQT_NO_DEBUG

	# Plugin selection
	use gadu && PLUGINS+=' gadu_protocol history_migration profiles_import'
	use mpd && PLUGINS+=' mpd_mediaplayer'
	use otr && PLUGINS+=' encryption_otr'
	use phonon && PLUGINS+=' phonon_sound'
	use speech && PLUGINS+=' speech'
	use spell && PLUGINS+=' spellchecker'
	use xmpp && PLUGINS+=' jabber_protocol'

	# Configure package
	local mycmakeargs=(
		-DBUILD_DESCRIPTION='Gentoo Linux'
		-DCOMPILE_PLUGINS="${PLUGINS}"
		-DNETWORK_IMPLEMENTATION="Qt"
		$(cmake-utils_use sdk INSTALL_SDK)
		$(cmake-utils_use_with spell ENCHANT)
	)
	unset PLUGINS

	cmake-utils_src_configure
}
