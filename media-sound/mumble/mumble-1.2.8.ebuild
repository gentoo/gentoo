# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mumble/mumble-1.2.8.ebuild,v 1.1 2014/10/30 21:50:38 tgurr Exp $

EAPI="5"

QT_MINIMAL="4.6"

inherit eutils multilib qt4-r2

MY_P="${PN}-${PV/_/~}"

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="http://mumble.sourceforge.net/"
SRC_URI="http://mumble.info/snapshot/${MY_P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa +dbus debug g15 oss pch portaudio pulseaudio speech zeroconf"

RDEPEND=">=dev-libs/boost-1.41.0
	>=dev-libs/openssl-1.0.0b
	>=dev-libs/protobuf-2.2.0
	>=media-libs/libsndfile-1.0.20[-minimal]
	>=media-libs/opus-1.0.1
	>=media-libs/speex-1.2_rc1
	sys-apps/lsb-release
	x11-libs/libX11
	x11-libs/libXi
	dev-qt/qtcore:4[ssl]
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtsvg:4
	dev-qt/qtxmlpatterns:4
	x11-proto/inputproto
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:4 )
	g15? ( app-misc/g15daemon )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	speech? ( app-accessibility/speech-dispatcher )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.4-speech-dispatcher.patch
)

S="${WORKDIR}/${MY_P}"

src_configure() {
	local conf_add

	if has_version '<=sys-devel/gcc-4.2'; then
		conf_add="${conf_add} no-pch"
	else
		use pch || conf_add="${conf_add} no-pch"
	fi

	use alsa || conf_add="${conf_add} no-alsa"
	use dbus || conf_add="${conf_add} no-dbus"
	use debug && conf_add="${conf_add} symbols debug" || conf_add="${conf_add} release"
	use g15 || conf_add="${conf_add} no-g15"
	use oss || conf_add="${conf_add} no-oss"
	use portaudio || conf_add="${conf_add} no-portaudio"
	use pulseaudio || conf_add="${conf_add} no-pulseaudio"
	use speech || conf_add="${conf_add} no-speechd"
	use zeroconf || conf_add="${conf_add} no-bonjour"

	eqmake4 "${S}/main.pro" -recursive \
		CONFIG+="${conf_add} \
			bundled-celt \
			no-bundled-opus \
			no-bundled-speex \
			no-embed-qt-translations \
			no-server \
			no-update" \
		DEFINES+="PLUGIN_PATH=/usr/$(get_libdir)/mumble"
}

src_compile() {
	# parallel make workaround, bug #445960
	emake -j1
}

src_install() {
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
	doins "${dir}"/libmumble.so.1.2.8
	dosym libmumble.so.1.2.8 /usr/$(get_libdir)/mumble/libmumble.so.1
	doins "${dir}"/libcelt0.so.0.{7,11}.0
	doins "${dir}"/plugins/lib*.so*
}

pkg_postinst() {
	echo
	elog "Visit http://mumble.sourceforge.net/ for futher configuration instructions."
	elog "Run mumble-overlay to start the OpenGL overlay (after starting mumble)."
	echo
}
