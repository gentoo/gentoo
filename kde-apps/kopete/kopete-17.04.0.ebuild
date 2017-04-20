# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE multi-protocol IM client"
HOMEPAGE="https://kopete.kde.org https://www.kde.org/applications/internet/kopete"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug ssl v4l"

# tests hang, last checked for 4.2.96
RESTRICT+=" test"

# Available plugins
#
#	addbookmarks: NO DEPS
#	alias: NO DEPS (disabled upstream)
#	autoreplace: NO DEPS
#	contactnotes: NO DEPS
#	cryptography: kde-apps/kdepim-common-libs:4 or kde-apps/libkleo:4
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
PLUGINS="+addbookmarks +autoreplace +contactnotes cryptography +highlight
+history latex +nowlistening otr +pipes +privacy +statistics +texteffect
+translator +urlpicpreview webpresence"

# Available protocols
#
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
#	yahoo: media-libs/jasper
#	zeroconf (bonjour): NO DEPS
PROTOCOLS="gadu groupwise jingle meanwhile oscar skype
testbed winpopup +xmpp yahoo zeroconf"

# disabled protocols
#	telepathy: net-libs/decibel
#	irc: NO DEPS
#	msn: net-libs/libmsn
#	qq: NO DEPS

IUSE="${IUSE} ${PLUGINS} ${PROTOCOLS}"

COMMONDEPEND="
	$(add_kdeapps_dep kdepimlibs)
	dev-libs/libpcre
	>=dev-qt/qtgui-4.4.0:4[mng]
	kde-frameworks/kdelibs:4[zeroconf?]
	media-libs/phonon[qt4]
	media-libs/qimageblitz
	!aqua? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
	cryptography? (
		|| (
			$(add_kdeapps_dep kdepim-common-libs)
			$(add_kdeapps_dep libkleo '' 4.4.2016.01-r1)
		)
	)
	gadu? ( >=net-libs/libgadu-1.8.0[threads] )
	groupwise? ( app-crypt/qca:2[qt4(+)] )
	jingle? (
		dev-libs/expat
		dev-libs/openssl:0
		>=media-libs/mediastreamer-2.3.0
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
		app-crypt/qca:2[qt4(+)]
		dev-libs/qjson
		net-dns/libidn
		sys-libs/zlib
	)
	yahoo? ( media-libs/jasper )
"
RDEPEND="${COMMONDEPEND}
	jingle? ( media-libs/speex )
	latex? (
		virtual/imagemagick-tools
		virtual/latex-base
	)
	ssl? ( app-crypt/qca:2[ssl] )
	winpopup? ( net-fs/samba )
"
DEPEND="${COMMONDEPEND}
	jingle? ( dev-libs/jsoncpp )
	!aqua? ( x11-proto/scrnsaverproto )
"

src_configure() {
	local x x2
	# Handle common stuff
	local mycmakeargs=(
		-DWITH_LiboRTP=$(usex jingle)
		-DWITH_Mediastreamer=$(usex jingle)
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

	mycmakeargs+=( -DWITH_Libmsn=OFF -DWITH_qq=OFF -DWITH_sms=OFF )

	# enable plugins
	for x in ${PLUGINS}; do
		mycmakeargs+=( -DWITH_${x/+/}=$(usex ${x/+/}) )
	done

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! use ssl; then
		if use xmpp ; then # || use irc; then
			if ! has_version "app-crypt/qca:2[ssl]" ; then
				elog "In order to use ssl in xmpp you'll need to"
				elog "install app-crypt/qca package with USE=ssl."
			fi
		fi
	fi
}
