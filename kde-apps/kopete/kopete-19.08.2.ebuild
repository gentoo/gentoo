# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Multi-protocol IM client based on KDE Frameworks"
HOMEPAGE="https://userbase.kde.org/Kopete https://kde.org/applications/internet/kopete"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="ssl v4l"

# Available plugins
#
#	addbookmarks: NO DEPS
#	alias: NO DEPS (disabled upstream)
#	autoreplace: NO DEPS
#	contactnotes: NO DEPS
#	cryptography: BROKEN (app-crypt/gpgme[cxx,qt5], kde-apps/libkleo:5)
#	highlight: NO DEPS
#	history: NO DEPS
#	latex: virtual/latex as RDEPEND
#	nowlistening: NO DEPS
#	otr: libotr
#	pipes: NO DEPS
#	privacy: NO DEPS
#	statistics: dev-db/sqlite:3
#	texteffect: NO DEPS
#	translator: NO DEPS
#	urlpicpreview: NO DEPS
#	webpresence: libxml2 libxslt
# NOTE: By default we enable all plugins that don't have any dependencies
PLUGINS="+addbookmarks +autoreplace +contactnotes +highlight history latex nowlistening
otr pipes +privacy +statistics +texteffect translator +urlpicpreview webpresence"

# Available protocols
#	gadu: net-libs/libgadu @since 4.3
#	groupwise: app-crypt/qca:2
#	irc: NO DEPS, probably will fail so inform user about it
#	xmpp: net-dns/libidn app-crypt/qca:2 ENABLED BY DEFAULT NETWORK
#	jingle: media-libs/speex net-libs/ortp DISABLED BY UPSTREAM
#	meanwhile: net-libs/meanwhile
#	oscar: NO DEPS
#	telepathy: net-libs/decibel
#	testbed: NO DEPS
#	winpopup: NO DEPS (we're adding samba as RDEPEND so it works)
#	zeroconf (bonjour): NO DEPS
PROTOCOLS="gadu groupwise jingle meanwhile oscar testbed winpopup +xmpp zeroconf"

# disabled protocols
#	irc: NO DEPS
#	qq: NO DEPS
#	telepathy: net-libs/decibel
#	skype, sms (until fixed)

IUSE="${IUSE} ${PLUGINS} ${PROTOCOLS}"

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcontacts)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktexteditor)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep libkleo)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/gpgme[cxx,qt5]
	dev-libs/libpcre
	media-libs/phonon[qt5(+)]
	x11-libs/libX11
	x11-libs/libXScrnSaver
	gadu? ( >=net-libs/libgadu-1.8.0[threads] )
	groupwise? ( app-crypt/qca:2[qt5(+)] )
	jingle? (
		dev-libs/expat
		dev-libs/openssl:0=
		>=media-libs/mediastreamer-2.3.0
		media-libs/speex
		net-libs/libsrtp:=
		net-libs/ortp:=
	)
	meanwhile? ( net-libs/meanwhile )
	otr? ( >=net-libs/libotr-4.0.0 )
	statistics? ( dev-db/sqlite:3 )
	v4l? ( media-libs/libv4l )
	webpresence? (
		dev-libs/libxml2
		dev-libs/libxslt
	)
	xmpp? (
		app-crypt/qca:2[qt5(+)]
		net-dns/libidn:0=
		sys-libs/zlib:=
	)
	zeroconf? (
		$(add_frameworks_dep kdnssd)
		$(add_kdeapps_dep kidentitymanagement)
	)
"
RDEPEND="${COMMON_DEPEND}
	latex? (
		|| (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
		)
		virtual/latex-base
	)
	ssl? ( app-crypt/qca:2[ssl] )
"
#	sms? ( app-mobilephone/smssend )
#	winpopup? ( net-fs/samba )
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	jingle? ( dev-libs/jsoncpp )
"

# tests hang, last checked for 4.2.96
RESTRICT+=" test"

src_configure() {
	local x x2
	# Handle common stuff
	local mycmakeargs=(
		-DWITH_qq=OFF
		$(cmake-utils_use_find_package jingle LiboRTP)
		$(cmake-utils_use_find_package jingle Mediastreamer)
		$(cmake-utils_use_find_package jingle Speex)
		-DDISABLE_VIDEOSUPPORT=$(usex !v4l)
	)
	# enable protocols
	for x in ${PROTOCOLS}; do
		case ${x/+/} in
			jingle) x2=libjingle ;;
			xmpp) x2=jabber ;;
			zeroconf) x2=bonjour ;;
			*) x2=${x/+/} ;;
		esac
		mycmakeargs+=( -DWITH_${x2}=$(usex ${x/+/}) )
	done

	# disable until fixed:
	mycmakeargs+=( -DWITH_{cryptography,libjingle,skype,sms}=OFF )

	# enable plugins
	for x in ${PLUGINS}; do
		mycmakeargs+=( -DWITH_${x/+/}=$(usex ${x/+/}) )
	done

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! use ssl; then
		if use xmpp ; then
			if ! has_version "app-crypt/qca:2[ssl]" ; then
				elog "In order to use ssl in xmpp you'll need to"
				elog "install app-crypt/qca package with USE=ssl."
			fi
		fi
	fi
}
