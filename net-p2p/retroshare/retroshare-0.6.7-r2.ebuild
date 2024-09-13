# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic desktop qmake-utils xdg

DESCRIPTION="Friend to Friend secure communication and sharing application"
HOMEPAGE="https://retroshare.cc"
SRC_URI="https://download.opensuse.org/repositories/network:/retroshare/Debian_Testing/retroshare-common_${PV}.orig.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/RetroShare"
# NOTE: GitHub releases/archive is impractical to build so we use the OBS repo
# but they squash point releases which is bad for us

LICENSE="AGPL-3 Apache-2.0 CC-BY-SA-4.0 GPL-2 GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli +gui +jsonapi keyring libupnp +miniupnp plugins +service +sqlcipher"

REQUIRED_USE="
	|| ( gui service )
	?? ( libupnp miniupnp )
	plugins? ( gui )
	service? ( || ( cli jsonapi ) )
"
RDEPEND="
	app-arch/bzip2
	dev-libs/openssl:0=
	sys-libs/zlib
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
	keyring? ( app-crypt/libsecret )
	libupnp? ( net-libs/libupnp:= )
	miniupnp? ( net-libs/miniupnpc:= )
	plugins? (
		media-libs/speex
		media-libs/speexdsp
		<media-video/ffmpeg-5
	)
	sqlcipher? ( dev-db/sqlcipher )
	!sqlcipher? ( dev-db/sqlite:3 )
"
DEPEND="
	${RDEPEND}
	gui? ( dev-qt/designer:5 )
	jsonapi? ( >=dev-libs/rapidjson-1.1.0 )
"
BDEPEND="
	dev-build/cmake
	dev-qt/qtcore:5
	virtual/pkgconfig
	gui? ( x11-base/xorg-proto )
	jsonapi? ( app-text/doxygen )
"
PATCHES=( "${FILESDIR}/${P}-fix-miniupnp-api-v18.patch" )

src_configure() {
	local qconfigs=(
		$(usex cli     '' 'no_')rs_service_terminal_login
		$(usex keyring '' 'no_')rs_autologin
		$(usex gui     '' 'no_')retroshare_gui
		$(usex jsonapi '' 'no_')rs_jsonapi
		$(usex service '' 'no_')retroshare_service
		$(usex sqlcipher '' 'no_')sqlcipher
		$(usex plugins '' 'no_')retroshare_plugins
	)

	local qupnplibs="none"
	use miniupnp && qupnplibs="miniupnpc"
	use libupnp && qupnplibs="upnp ixml"

	# bug 907898
	use elibc_musl && append-flags -D_LARGEFILE64_SOURCE

	# REVIEW: qmake is deprecated
	# https://github.com/RetroShare/RetroShare/tree/master/jsonapi-generator
	eqmake5 CONFIG+="${qconfigs[*]}" \
		RS_MAJOR_VERSION=$(ver_cut 1) \
		RS_MINOR_VERSION=$(ver_cut 2) \
		RS_MINI_VERSION=$(ver_cut 3) \
		RS_EXTRA_VERSION="-gentoo-${PR}" \
		RS_UPNP_LIB="${qupnplibs}"
}

src_install() {
	use gui && dobin retroshare-gui/src/retroshare
	use service && dobin retroshare-service/src/retroshare-service

	insinto /usr/share/retroshare
	doins libbitdht/src/bitdht/bdboot.txt
	use gui && doins -r retroshare-gui/src/qss

	dodoc README.asciidoc

	if use gui; then
		make_desktop_entry retroshare

		for i in 24 48 64 128 ; do
			doicon -s ${i} "data/${i}x${i}/apps/retroshare.png"
		done
	fi
	if use plugins; then
		insinto /usr/lib/retroshare/extensions6
		doins plugins/*/lib/*.so
	fi
}

pkg_preinst() {
	xdg_pkg_preinst

	if ! use sqlcipher && ! has_version "net-p2p/retroshare[-sqlcipher]"; then
		ewarn "You have disabled GXS database encryption, ${PN} will use SQLite"
		ewarn "instead of SQLCipher for GXS databases."
		ewarn "Builds using SQLite and builds using SQLCipher have incompatible"
		ewarn "database format, so you will need to manually delete GXS"
		ewarn "database (loosing all your GXS data and identities) when you"
		ewarn "toggle sqlcipher USE flag."
	fi
}
