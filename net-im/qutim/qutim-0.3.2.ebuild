# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/qutim/qutim-0.3.2.ebuild,v 1.9 2015/06/04 19:05:03 kensington Exp $

EAPI=5

LANGS="ar be bg cs de en_GB es fr he nds ru sk uk uz zh_CN"

inherit qt4-r2 cmake-utils

DESCRIPTION="Qt4-based multi-protocol instant messenger"
HOMEPAGE="http://www.qutim.org"
SRC_URI="http://www.qutim.org/dwnl/68/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# general USE
IUSE="doc +sound tools"
# protocol uses
IUSE="$IUSE telepathy irc xmpp jingle mrim oscar purple vkontakte"
# plugins
IUSE="$IUSE antiboss aspell ayatana awn crypt dbus debug -espionage histman hunspell
	kde mobility otr plugman phonon purple qml sdl +ssl +xscreensaver webkit"

REQUIRED_USE="
	oscar? ( ssl )
	jingle? ( xmpp )
	qml? ( webkit )
"

# Minimum Qt version required
QT_PV="4.7.0:4"

CDEPEND="
	x11-libs/libqxt
	>=dev-qt/qtcore-${QT_PV}[ssl?]
	>=dev-qt/qtgui-${QT_PV}
	>=dev-qt/qtscript-${QT_PV}
	>=dev-qt/qtdeclarative-${QT_PV}

	telepathy? ( >=net-libs/telepathy-qt-0.3 )
	xmpp? (
		app-crypt/qca:2[qt4(+)]
		>=net-libs/jreen-1.2.0
	)
	jingle? ( dev-qt/qt-mobility[multimedia] )
	oscar? ( app-crypt/qca:2[qt4(+)] )
	purple? ( net-im/pidgin )
	vkontakte? ( >=dev-qt/qtwebkit-${QT_PV} )

	aspell? ( app-text/aspell )
	awn? ( >=dev-qt/qtdbus-${QT_PV} )
	crypt? ( app-crypt/qca:2[qt4(+)] )
	dbus? ( >=dev-qt/qtdbus-${QT_PV} )
	espionage? ( app-crypt/qca:2[qt4(+)] )
	histman? ( >=dev-qt/qtsql-${QT_PV} )
	ayatana? ( >=dev-libs/libindicate-qt-0.2.2 )
	hunspell? ( app-text/hunspell )
	kde? ( kde-base/kdelibs:4 )
	mobility? (
		dev-qt/qt-mobility[multimedia,feedback]
		>=dev-qt/qtbearer-${QT_PV}
	)
	otr? (
		>=net-libs/libotr-3.2.0
		<net-libs/libotr-4.0.0
	)
	phonon? (
		kde? ( media-libs/phonon[qt4] )
		!kde? ( || ( >=dev-qt/qtphonon-${QT_PV} media-libs/phonon[qt4] ) )
	)
	plugman? (
		dev-libs/libattica
		app-arch/libarchive
	)
	qml? (
		>=dev-qt/qtopengl-${QT_PV}
	)
	sdl? ( media-libs/sdl-mixer )
	xscreensaver? ( x11-libs/libXScrnSaver )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	kde? ( dev-util/automoc )
"
RDEPEND="${CDEPEND}
	xmpp? ( app-crypt/qca:2[gpg] )
	oscar? ( app-crypt/qca:2[openssl] )
	kde-apps/oxygen-icons
"

DOCS=( AUTHORS INSTALL ChangeLog )
PATCHES=(
	"${FILESDIR}/${PN}-0.3.1-cmake-2.8.12-kde-build.patch"
	"${FILESDIR}/${P}-astral-migrate-qt-telepaphy.patch"
)

src_prepare() {
	# fix automagic dep on libXScrnSaver
	if ! use xscreensaver; then
		sed -i -e '/XSS xscrnsaver/d' \
			core/src/corelayers/idledetector/CMakeLists.txt || die
	fi

	# fix automagic dep on qt-mobility for jingle
	if ! use jingle; then
		sed -i -e '/find_package(QtMobility)/d' \
			protocols/jabber/CMakeLists.txt || die
	fi

	# remove unwanted translations
	local lang
	for lang in ${LANGS}; do
		use linguas_${lang} || rm -f translations/modules/*/${lang}.{po,ts}
	done

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYSTEM_JREEN=ON
		$(cmake-utils_use_with doc DOXYGEN)
		$(cmake-utils_use doc     QUTIM_GENERATE_DOCS)
		$(cmake-utils_use sound   QUTIM_INSTALL_SOUND_THEME  )
		$(cmake-utils_use tools   QUTIM_DEVELOPER_BUILD      )

		# protocols
		$(cmake-utils_use telepathy ASTRAL )
		$(cmake-utils_use irc              )
		$(cmake-utils_use xmpp JABBER      )
		$(cmake-utils_use mrim             )
		$(cmake-utils_use oscar            )
		$(cmake-utils_use purple QUETZAL   )
		$(cmake-utils_use vkontakte        )

		# plugins
		$(cmake-utils_use  webkit      ADIUMWEBVIEW      )
		$(cmake-utils_use  crypt       AESCRYPTO         )
		$(cmake-utils_use  antiboss    ANTIBOSS          )
		$(cmake-utils_use  aspell      ASPELLER          )
		$(cmake-utils_use  awn         AWN               )
		$(cmake-utils_use  espionage   CONTROL           ) # Also requires -DENABLE_ESPIONAGE=ON (see bellow)
		$(cmake-utils_use  dbus        DBUSAPI           )
		$(cmake-utils_use  dbus        DBUSNOTIFICATIONS )
		$(cmake-utils_use  histman     HISTMAN           )
		$(cmake-utils_use  hunspell    HUNSPELLER        )
		$(cmake-utils_use  ayatana     INDICATOR         )
		$(cmake-utils_use  kde         KDEINTEGRATION    )
		$(cmake-utils_use  qml         KINETICPOPUPS     )
		$(cmake-utils_use  phonon      PHONONSOUND       )
		$(cmake-utils_use  plugman     PLUGMAN           )
		$(cmake-utils_use  debug       LOGGER            )
		$(cmake-utils_use  mobility    MOBILITY          )
		$(cmake-utils_use  dbus        NOWPLAYING        )
		$(cmake-utils_use  otr         OFFTHERECORD      )
		$(cmake-utils_use  qml         QMLCHAT           )
		$(cmake-utils_use  sdl         SDLSOUND          )
		$(cmake-utils_use_enable espionage               )
		-DLINUXINTEGRATION=ON
		-DDOCKTILE=OFF	# QtDockTile currenly supports only unity;
						# consider to make it optional if it also support kde or whatever
		-DUPDATER=OFF
	)
	# NOTE: Integration plugins are autodisabled:
	# symbianintegration macintegration maemo5integration haikunotifications meegointegration winintegration

	cmake-utils_src_configure
}

pkg_postinst () {
	elog "Next qutim plugins are enabled by default:"
	elog "  antispam autopaster autoreply birthdayreminder blogimprover clconf"
	elog "  emoedit floaties formula highlighter imagepub massmessaging"
	elog "  oldcontactdelegate qrcicons screenshoter scriptapi unreadmessageskeeper urlpreview"
	elog "  weather webhistory yandexnarod"
	elog "If you have strong reasons to make their build optional feel free to fill bugrepot."

	if use espionage; then
		ewarn "You have enabled the control (espionage) plugin. It may "
		ewarn "deal negative security impact on the privacy of your client."
	fi
}
