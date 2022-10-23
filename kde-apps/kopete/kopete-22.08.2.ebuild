# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Multi-protocol IM client based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kopete/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="ssl v4l"

# Available plugins
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
#	meanwhile: net-libs/meanwhile
#	oscar: NO DEPS
#	telepathy: net-libs/decibel
#	testbed: NO DEPS
#	winpopup: NO DEPS (we're adding samba as RDEPEND so it works)
#	zeroconf (bonjour): NO DEPS
PROTOCOLS="gadu groupwise meanwhile oscar testbed winpopup +xmpp zeroconf"

# disabled protocols
#	irc: NO DEPS
#	jingle: media-libs/speex net-libs/ortp DISABLED BY UPSTREAM
#	qq: NO DEPS
#	telepathy: net-libs/decibel
#	skype, sms (until fixed)

IUSE="${IUSE} ${PLUGINS} ${PROTOCOLS}"

COMMON_DEPEND="
	app-crypt/gpgme:=[cxx,qt5]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/libkleo-${PVCUT}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kemoticons-${KFMIN}:5
	>=kde-frameworks/khtml-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=media-libs/phonon-4.11.0
	x11-libs/libX11
	x11-libs/libXScrnSaver
	gadu? ( >=net-libs/libgadu-1.8.0[threads] )
	groupwise? ( >=app-crypt/qca-2.3.0:2[qt5(+)] )
	meanwhile? ( net-libs/meanwhile )
	otr? ( >=net-libs/libotr-4.0.0 )
	statistics? ( dev-db/sqlite:3 )
	v4l? ( media-libs/libv4l )
	webpresence? (
		dev-libs/libxml2
		dev-libs/libxslt
	)
	xmpp? (
		>=app-crypt/qca-2.3.0:2[qt5(+)]
		net-dns/libidn:0=
		sys-libs/zlib
	)
	zeroconf? (
		>=kde-apps/kidentitymanagement-${PVCUT}:5
		>=kde-frameworks/kdnssd-${KFMIN}:5
	)
"
#	jingle? (
#		dev-libs/expat
#		dev-libs/openssl:0=
#		>=media-libs/mediastreamer-2.3.0
#		media-libs/speex
#		net-libs/libsrtp:0=
#		net-libs/ortp:=
#	)
RDEPEND="${COMMON_DEPEND}
	latex? (
		|| (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
		)
		virtual/latex-base
	)
	ssl? ( >=app-crypt/qca-2.3.0:2[qt5(+),ssl] )
	xmpp? ( >=app-crypt/qca-2.3.0:2[qt5(+),ssl?] )
"
#	sms? ( app-mobilephone/smssend )
#	winpopup? ( net-fs/samba )
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
#	jingle? ( dev-libs/jsoncpp )

# tests hang, last checked for 4.2.96
RESTRICT="test"

src_configure() {
	local x x2
	# Handle common stuff
	local mycmakeargs=(
		-DWITH_qq=OFF
		-DDISABLE_VIDEOSUPPORT=$(usex !v4l)
	)
#		$(cmake_use_find_package jingle LiboRTP)
#		$(cmake_use_find_package jingle Mediastreamer)
#		$(cmake_use_find_package jingle Speex)

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

	ecm_src_configure
}
