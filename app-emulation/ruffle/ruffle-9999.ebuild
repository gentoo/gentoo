# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo desktop git-r3 xdg

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
EGIT_REPO_URI="https://github.com/ruffle-rs/ruffle.git"

LICENSE="|| ( Apache-2.0 MIT )"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CC0-1.0 ISC UbuntuFontLicense-1.0 MIT MPL-2.0 OFL-1.1
	Unicode-DFS-2016 ZLIB curl
" # crates
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# dlopen: libX* (see winit+x11-dl crates)
RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/alsa-lib
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXrender
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/jre:*
	virtual/pkgconfig
	>=virtual/rust-1.72
"

QA_FLAGS_IGNORED="usr/bin/${PN}.*"

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20231216-skip-render-tests.patch
)

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	# see .cargo/config.toml, only needed if RUSTFLAGS is set by the user
	[[ -v RUSTFLAGS ]] && RUSTFLAGS+=" --cfg=web_sys_unstable_apis"

	local workspaces=(
		ruffle_{desktop,scanner}
		exporter
		$(usev test tests)
	)

	cargo_src_configure "${workspaces[@]/#/--package=}"
}

src_test() {
	local skip=(
		# may need more investigation, strangely "pass" (xfail) when
		# RUSTFLAGS is unset, skip for now (bug #915726)
		--skip from_avmplus/as3/Types/Int/wraparound
	)

	cargo_src_test -- "${skip[@]}"
}

src_install() {
	dodoc README.md

	newicon web/packages/extension/assets/images/icon180.png ${PN}.png
	make_desktop_entry ${PN} ${PN^} ${PN} "AudioVideo;Player;Emulator;" \
		"MimeType=application/x-shockwave-flash;application/vnd.adobe.flash.movie;"

	# TODO: swap with /gentoo after https://github.com/gentoo/gentoo/pull/29510
	cd target/$(usex debug{,} release) || die

	newbin ${PN}_desktop ${PN}
	newbin exporter ${PN}_exporter
	dobin ${PN}_scanner
}
