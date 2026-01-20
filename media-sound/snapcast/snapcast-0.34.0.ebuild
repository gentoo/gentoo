# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake edo optfeature python-single-r1 systemd

DESCRIPTION="Synchronous multi-room audio player"
HOMEPAGE="https://github.com/snapcast/snapcast"
SRC_URI="https://github.com/snapcast/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
IUSE="alsa +client +expat +flac jack +opus pipewire python +server soxr ssl test tremor +vorbis +zeroconf"
REQUIRED_USE="
	|| ( server client )
	server? (
		python? ( ${PYTHON_REQUIRED_USE} )
	)
"
RESTRICT="!test? ( test )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	client? (
		acct-user/snapclient
		tremor? (
			media-libs/libogg
			media-libs/tremor
		)
	)
	flac? ( media-libs/flac:= )
	jack? ( virtual/jack )
	opus? ( media-libs/opus )
	pipewire? ( media-video/pipewire:= )
	server? (
		acct-group/snapserver
		>=acct-user/snapserver-0-r3
		expat? ( dev-libs/expat )
		python? ( ${PYTHON_DEPS} )
	)
	soxr? ( media-libs/soxr )
	ssl? ( dev-libs/openssl:= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-libs/boost:=
	jack? ( dev-libs/boost:=[context] )
	test? (
		>=dev-cpp/catch-3:0
		dev-libs/openssl
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.34.0-snapclient_group.patch
	"${FILESDIR}"/${PN}-0.34.0-opt_soxr.patch
	"${FILESDIR}"/${PN}-0.34.0-drop-lint.patch
)

pkg_setup() {
	use server && use python && python-single-r1_pkg_setup
}

src_prepare() {
	# 3rd-party
	rm common/json.hpp || die
	sed -e 's@"common/json.hpp"@<nlohmann/json.hpp>@' \
		-i common/message/json_message.hpp \
		-i common/stream_uri.hpp \
		-i server/control_server.cpp \
		-i server/streamreader/metadata.hpp \
		-i server/streamreader/pcm_stream.hpp \
		-i server/streamreader/properties.hpp \
		-i server/config.hpp \
		-i server/jsonrpcpp.hpp \
		-i server/jwt.hpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_STATIC_LIBS=no
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DBUILD_WITH_ALSA=$(usex alsa)
		-DBUILD_WITH_AVAHI=$(usex zeroconf)
		-DBUILD_WITH_EXPAT=$(usex expat)
		-DBUILD_WITH_FLAC=$(usex flac)
		-DBUILD_WITH_JACK=$(usex jack)
		-DBUILD_WITH_OPUS=$(usex opus)
		-DBUILD_WITH_PIPEWIRE=$(usex pipewire)
		-DBUILD_WITH_SOXR=$(usex soxr)
		-DBUILD_WITH_SSL=$(usex ssl)
		-DBUILD_WITH_TREMOR=$(usex tremor)
		-DBUILD_WITH_VORBIS=$(usex vorbis)
	)

	cmake_src_configure
}

src_test() {
	edo "${S}"/bin/snapcast_test
}

src_install() {
	cmake_src_install

	local bin
	for bin in server client ; do
		if use ${bin} ; then
			doman ${bin}/snap${bin}.1

			newconfd "${FILESDIR}"/snap${bin}.confd-r1 snap${bin}
			newinitd "${FILESDIR}"/snap${bin}.initd-r1 snap${bin}
			systemd_dounit extras/package/rpm/snap${bin}.service
		fi
	done

	if use server; then
		if use python; then
			python_fix_shebang "${ED}"/usr/share/snapserver/plug-ins
		else
			rm "${ED}"/usr/share/snapserver/plug-ins/*.py || die
		fi
	fi
}

pkg_postinst() {
	if use client && ! use zeroconf; then
		ewarn "zeroconf is disabled but the url by default is 'tcp://_snapcast._tcp'."
		ewarn "Please define an url in SNAPCLIENT_OPTS into ${EROOT}/etc/conf.d/snapclient"
	fi
	if use server && use python; then
		optfeature "librespot stream plugin" dev-python/websocket-client dev-python/requests
		optfeature "mopidy stream plugin" dev-python/websocket-client
		optfeature "mpd stream plugin" dev-python/dbus-python dev-python/musicbrainzngs
		optfeature "mpd stream plugin" dev-python/pygobject dev-python/python-mpd2
	fi
}
