# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIRTUALX_REQUIRED=test

inherit autotools optfeature prefix toolchain-funcs virtualx xdg

DESCRIPTION="Enhanced game engine version from the classic Mac game, Marathon"
HOMEPAGE="https://alephone.lhowon.org/"
if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aleph-One-Marathon/alephone/"
	EGIT_SUBMODULES=() # Upstream includes game data as submodules, we only want the engine
else
	SRC_URI="https://github.com/Aleph-One-Marathon/alephone/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-release-${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-3+ BitstreamVera OFL-1.1"
SLOT="0"
IUSE="curl test upnp video-export"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/zziplib:=
	media-libs/openal
	media-libs/libpng
	media-libs/libsdl2[joystick]
	media-libs/libsndfile[-minimal]
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf
	virtual/zlib:=
	virtual/opengl
	virtual/glu
	curl? ( net-misc/curl )
	upnp? ( net-libs/miniupnpc )
	video-export? (
		dev-libs/libebml:=
		media-libs/libmatroska:=
		media-libs/libvorbis
		media-libs/libvpx:=
		media-libs/libyuv:=
	)
"
DEPEND="${RDEPEND}
	dev-cpp/asio
	test? (
		>=dev-cpp/catch-3:0
		games-fps/alephone-durandal
		games-fps/alephone-infinity
		games-fps/alephone-marathon
	)
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	my_econf=(
		--enable-opengl
		--disable-steam # not packaged?
		--without-nfd # not packaged?
		--with-png
		--with-sdl_image
		--with-zzip
		$(use_with curl)
		$(use_with test catch2)
		$(use_with upnp miniupnpc)
		$(use_with video-export ebml)
		$(use_with video-export matroska)
		$(use_with video-export vpx)
		$(use_with video-export vorbis)
		$(use_with video-export vorbisenc)
		$(use_with video-export libyuv)
	)
	econf "${my_econf[@]}"
}

src_compile() {
	tc-export AR
	default
}

src_test() {
	# We only have the replay regression tests available, but they're better than nothing.
	for p in marathon durandal infinity; do
		local replay_path
		case "${p}" in
		marathon)
			replay_path="${S}/tests/replays/Marathon/Tooncinator Films"
			;;
		durandal)
			replay_path="${S}/tests/replays/Marathon 2"
			;;
		infinity)
			replay_path="${S}/tests/replays/Marathon Infinity/Tooncinator Films"
			;;
		esac
		einfo "Running replay tests for alephone-${p}"
		einfo "This will take several minutes."
		virtx ./Source_Files/alephone_tests --replay-directory "${replay_path}" \
			"${EPREFIX}/usr/share/alephone-${p}" || die "Replay tests for alephone-${p} failed"
	done
}

src_install() {
	default
	prefixify_ro "${FILESDIR}"/${PN}.sh
	dobin "${T}"/${PN}.sh
	doman docs/${PN}.6
	docinto html/
	dodoc docs/*.html
	if use test; then
		rm "${D}"/usr/bin/${PN}_tests || die "Failed to remove test binary"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature_header "Install game data:"
	optfeature "Marathon data files" games-fps/alephone-marathon
	optfeature "Marathon 2 Durandal data files" games-fps/alephone-durandal
	optfeature "Marathon: Infinity data files" games-fps/alephone-infinity
	optfeature "Apotheosis X data files" games-fps/alephone-apotheosis-x
}
