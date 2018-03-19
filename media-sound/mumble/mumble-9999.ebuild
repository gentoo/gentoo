# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib desktop qmake-utils xdg-utils

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"
	EGIT_SUBMODULES=( '-*' celt-0.7.0-src celt-0.11.0-src themes/Mumble )
else
	MY_P="${PN}-${PV/_/~}"
	SRC_URI="https://mumble.info/snapshot/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa +dbus debug g15 libressl +opus oss pch portaudio pulseaudio speech zeroconf"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=dev-libs/protobuf-2.2.0:=
	>=media-libs/libsndfile-1.0.20[-minimal]
	|| (
		(
			>=media-libs/speex-1.2.0
			media-libs/speexdsp
		)
		<media-libs/speex-1.2.0
	)
	sys-apps/lsb-release
	x11-libs/libX11
	x11-libs/libXi
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	g15? ( app-misc/g15daemon )
	!libressl? ( >=dev-libs/openssl-1.0.0b:0= )
	libressl? ( dev-libs/libressl )
	opus? ( >=media-libs/opus-1.0.1 )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	speech? ( >=app-accessibility/speech-dispatcher-0.8.0 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.41.0
	virtual/pkgconfig
	x11-proto/inputproto
"

src_configure() {
	myuse() {
		[[ -n "${1}" ]] || die "myuse: No use option given"
		use ${1} || echo no-${1}
	}

	local conf_add=(
		bundled-celt
		no-bundled-opus
		no-bundled-speex
		no-embed-qt-translations
		no-server
		no-update
		$(myuse alsa)
		$(myuse dbus)
		$(usex debug 'symbols debug' release)
		$(myuse g15)
		$(myuse opus)
		$(myuse oss)
		$(myuse portaudio)
		$(myuse speech)
		$(usex zeroconf '' no-bonjour)
	)

	if has_version '<=sys-devel/gcc-4.2'; then
		conf_add+=( no-pch )
	else
		use pch || conf_add+=( no-pch )
	fi

	eqmake5 "${S}/main.pro" -recursive \
		CONFIG+="${conf_add[*]}" \
		DEFINES+="PLUGIN_PATH=/usr/$(get_libdir)/mumble"
}

src_install() {
	local soversion
	if [[ "${PV}" = 9999 ]] ; then
		soversion="$(sed -n '/^VERSION\b/s@.*= \([[:digit:]\.]\+\)$@\1@p' src/mumble.pri)"
	else
		soversion="${PV}"
	fi

	newdoc README.Linux README
	dodoc CHANGES

	local dir
	if use debug; then
		dir=debug
	else
		dir=release
	fi

	dobin "${dir}"/mumble
	dobin scripts/mumble-overlay

	insinto /usr/share/services
	doins scripts/mumble.protocol

	domenu scripts/mumble.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins icons/mumble.svg

	doman man/mumble-overlay.1
	doman man/mumble.1

	insopts -o root -g root -m 0755
	insinto "/usr/$(get_libdir)/mumble"
	doins "${dir}"/libmumble.so.${soversion}
	dosym libmumble.so.${soversion} /usr/$(get_libdir)/mumble/libmumble.so.1
	doins "${dir}"/libcelt0.so.0.{7,11}.0
	doins "${dir}"/plugins/lib*.so*
}

pkg_postinst() {
	xdg_desktop_database_update
	echo
	elog "Visit http://mumble.sourceforge.net/ for futher configuration instructions."
	elog "Run mumble-overlay to start the OpenGL overlay (after starting mumble)."
	echo
}

pkg_postrm() {
	xdg_desktop_database_update
}
