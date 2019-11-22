# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils flag-o-matic gnome2-utils virtualx

MY_P="${P/_/-}"

DESCRIPTION="An open source Gadu-Gadu and Jabber/XMPP protocol Instant Messenger client"
HOMEPAGE="http://www.kadu.net"
SRC_URI="http://download.kadu.im/stable/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="+gadu mpd otr sdk speech spell xmpp"
REQUIRED_USE="
	|| (
		gadu
		xmpp
	)
"
COMMON_DEPEND="
	>=app-arch/libarchive-2.6[lzma]
	>=dev-libs/injeqt-1.1.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXext
	x11-libs/libXScrnSaver
	gadu? ( >=net-libs/libgadu-1.12.2[threads] )
	mpd? ( media-libs/libmpdclient )
	otr? (
		>=dev-libs/libgcrypt-1.2.2:0
		>=net-libs/libotr-4.1.0
	)
	spell? ( app-text/enchant )
	xmpp? (
		net-dns/libidn:*
		>=net-libs/qxmpp-0.9.3-r1
		sys-libs/zlib
	)
"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	speech? ( app-accessibility/powiedz )
"

PLUGINS='
antistring
auto_hide
autoaway
autoresponder
autostatus
cenzor
chat_notify
config_wizard
docking
docking_notify
emoticons
exec_notify
ext_sound
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
screenshot
simpleview
single_window
sms
sound
sql_history
tabs
word_fix
'

PATCHES=(
	"${FILESDIR}/${PN}-4.3-do-not-force-ccache.patch"
	"${FILESDIR}/${PN}-4.3-fix-plugins-rpath.patch"
	"${FILESDIR}/${PN}-4.3-gcc7.patch"
	"${FILESDIR}/${PN}-4.3-find-x11-with-newer-cmake-modules.patch"
)

src_configure() {
	# Filter out dangerous flags
	filter-flags -fno-rtti
	strip-unsupported-flags

	# Ensure -DQT_NO_DEBUG is added
	append-cppflags -DQT_NO_DEBUG

	# Plugin selection
	use gadu && PLUGINS+=' gadu_protocol'
	use mpd && PLUGINS+=' mpd_mediaplayer'
	use otr && PLUGINS+=' encryption_otr'
	use speech && PLUGINS+=' speech'
	use spell && PLUGINS+=' spellchecker'
	use xmpp && PLUGINS+=' jabber_protocol'

	# Configure package
	local mycmakeargs=(
		-DCOMPILE_PLUGINS="${PLUGINS}"
		-DENABLE_TESTS=OFF
		-DNETWORK_IMPLEMENTATION="Qt"
		-DINSTALL_SDK=$(usex sdk)
		-DWITH_ENCHANT=$(usex spell)
	)
	unset PLUGINS

	cmake-utils_src_configure
}

src_test() {
	virtx cmake-utils_src_test
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
