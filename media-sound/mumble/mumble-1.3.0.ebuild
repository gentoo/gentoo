# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop multilib-build qmake-utils xdg

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"
	EGIT_SUBMODULES=( '-*' celt-0.7.0-src celt-0.11.0-src themes/Mumble 3rdparty/rnnoise-src )
else
	if [[ "${PV}" == *_pre* ]] ; then
		SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${P}.tar.xz"
	else
		MY_PV="${PV/_/-}"
		MY_P="${PN}-${MY_PV}"
		SRC_URI="https://github.com/mumble-voip/mumble/releases/download/${MY_PV}/${MY_P}.tar.gz
			https://dl.mumble.info/${MY_P}.tar.gz"
		S="${WORKDIR}/${P/_*}"
	fi
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa +dbus debug g15 jack libressl +opus oss pch portaudio pulseaudio +rnnoise speech zeroconf"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=dev-libs/protobuf-2.2.0:=
	>=media-libs/libsndfile-1.0.20[-minimal]
	>=media-libs/speex-1.2.0
	media-libs/speexdsp
	sys-apps/lsb-release
	x11-libs/libX11
	x11-libs/libXi
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	g15? ( app-misc/g15daemon )
	jack? ( virtual/jack )
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
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

# NB: qmake does not support multilib but it's fine to configure
# for the native ABI here
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
		$(usex jack '' no-jackaudio)
		$(myuse opus)
		$(myuse oss)
		$(myuse portaudio)
		$(myuse pulseaudio)
		$(myuse rnnoise)
		$(usex speech '' no-speechd)
		$(usex zeroconf '' no-bonjour)
	)

	use pch || conf_add+=( no-pch )

	eqmake5 "${S}/main.pro" -recursive \
		CONFIG+="${conf_add[*]}" \
		DEFINES+="PLUGIN_PATH=/usr/$(get_libdir)/mumble"
}

multilib_src_compile() {
	local emake_args=(
		# place libmumble* in a subdirectory
		DESTDIR_ADD="/${MULTILIB_ABI_FLAG}"
		{C,L}FLAGS_ADD="$(get_abi_CFLAGS)"
	)
	# build only overlay library for other ABIs
	multilib_is_native_abi || emake_args+=( -C overlay_gl )
	emake "${emake_args[@]}"
	emake clean
}

src_compile() {
	multilib_foreach_abi multilib_src_compile
}

multilib_src_install() {
	local dir=$(usex debug debug release)
	dolib.so "${dir}/${MULTILIB_ABI_FLAG}"/libmumble.so*
	if multilib_is_native_abi; then
		dobin "${dir}"/mumble
		dolib.so "${dir}"/libcelt0.so* "${dir}"/plugins/lib*.so*
	fi
}

src_install() {
	multilib_foreach_abi multilib_src_install

	newdoc README.Linux README
	dodoc CHANGES
	dobin scripts/mumble-overlay

	insinto /usr/share/services
	doins scripts/mumble.protocol

	domenu scripts/mumble.desktop

	doicon -s scalable icons/mumble.svg

	doman man/mumble-overlay.1
	doman man/mumble.1
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	echo
	elog "Visit http://mumble.sourceforge.net/ for futher configuration instructions."
	elog "Run mumble-overlay to start the OpenGL overlay (after starting mumble)."
	echo
}

pkg_postrm() {
	xdg_pkg_postrm
}
