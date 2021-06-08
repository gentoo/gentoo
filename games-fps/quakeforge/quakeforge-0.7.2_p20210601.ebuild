# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic readme.gentoo-r1 toolchain-funcs

MY_COMMIT="53b553e89234306dc0111b107308fb42998e522b"

DESCRIPTION="3D engine based on id Software's Quake and QuakeWorld game engines"
HOMEPAGE="http://www.quakeforge.net/"
SRC_URI="https://github.com/quakeforge/quakeforge/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa +client custom-cflags debug doc flac ipv6 jack ncurses oss png sdl vorbis wildmidi zlib"

RDEPEND="
	client? (
		media-libs/libsamplerate
		net-misc/curl
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		alsa? ( media-libs/alsa-lib )
		flac? ( media-libs/flac )
		jack? ( virtual/jack )
		sdl? ( media-libs/libsdl[sound] )
		vorbis? ( media-libs/libvorbis )
		wildmidi? ( media-sound/wildmidi )
	)
	ncurses? ( sys-libs/ncurses:= )
	png? ( media-libs/libpng:= )
	zlib? ( sys-libs/zlib:= )"
DEPEND="
	${RDEPEND}
	client? (
		virtual/opengl
		x11-base/xorg-proto
	)"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		media-gfx/transfig
	)"

PATCHES=(
	"${FILESDIR}"/${P}-png-stub.patch
	"${FILESDIR}"/${P}-skipped-tests.patch
)

src_prepare() {
	default

	echo ${PV} > .tarball-version || die

	eautoreconf
}

src_configure() {
	if ! use custom-cflags; then
		# package does a lot of fragile micro-optimizations
		strip-flags

		# nq-x11 segfaults starting a new game with -O2+ and gcc11
		# https://github.com/quakeforge/quakeforge/issues/12
		tc-is-gcc && [[ $(gcc-major-version) -ge 11 ]] && replace-flags '-O[2-9]*' -Os
	fi

	append-ldflags -Wl,-z,noexecstack

	qf_client() {
		echo $(usex client $(use_enable ${1}) --disable-${1})
	}

	local econfargs=(
		$(qf_client alsa)
		$(qf_client flac)
		$(qf_client jack)
		$(qf_client oss)
		$(qf_client sdl)
		$(qf_client vorbis)
		# vulkan is work-in-progress and currently needs <=vulkan-headers-1.2.169
		# https://github.com/quakeforge/quakeforge/issues/13
		--disable-vulkan # $(qf_client vulkan)
		$(qf_client wildmidi)
		$(use_enable client sound)
		$(use_enable client vidmode)
		$(use_enable debug)
		$(use_enable ncurses curses)
		$(use_enable png)
		$(use_enable zlib)
		$(use_with client x)
		$(use_with ipv6)
		--disable-Werror
		--disable-dga
		--disable-static
		--enable-xdg
		# non-x11 clients are mostly abandoned/broken (SDL1 still useful for pulseaudio)
		--with-clients=$(usex client x11 '')
		--with-cpp="$(tc-getCPP) -x c %u %d %s -o %o %i" # see config.d/qfcc.m4
		--with-global-cfg="${EPREFIX}"/etc/quakeforge.conf
		--with-sharepath="${EPREFIX}"/usr/share/quake1
	)

	# Jack audio is special (need a different method to enable), and an
	# issue prevents it from being usable without another audio output.
	# https://github.com/quakeforge/quakeforge/issues/16
	# Given hopefully temporary, not relying on REQUIRED_USE.
	use alsa || use oss || use sdl || econfargs+=( --enable-oss )

	econf "${econfargs[@]}"
}

src_compile() {
	default

	use doc && emake doc
}

src_install() {
	use doc && local HTML_DOCS=( doxygen/html/. )

	emake -j1 DESTDIR="${D}" install

	find "${ED}" -name '*.la' -delete || die

	local DISABLE_AUTOFORMATTING="yes"
	local DOC_CONTENTS=\
"Before you can play (using nq-x11 or qw-client-x11), you must ensure
that ${PN} can find your Quake pak0.pak (and optionally pak1.pak)
at one of these locations with lowercase filenames:
	- '~/.local/share/${PN}/id1/pak0.pak'
	- '${EPREFIX}/usr/share/quake1/id1/pak0.pak'

You can add them yourself or use either of:
	- games-fps/quake1-data: install from a Quake CD-ROM
	- games-fps/quake1-demodata: pak0.pak only (limited demo)

Key binds notes:
	Defaults ('imt_mod' table) expect you to set key binds manually in:
	- '~/.local/share/${PN}/id1/autoexec.cfg' (or '${EPREFIX}/usr/share/quake1/id1')
	For the in-game bind menu to be usable ('imt_0' table), bring up the
	console with backtick \`, and run 'imt imt_0' (only needed once).
	A mouse-grab bind ('toggle in_grab') and using freelook is recommended.

Audio/Video notes:
	Can add settings in:
	- '~/.config/${PN}/${PN}.conf' (or '${EPREFIX}/etc/${PN}.conf')
	Examples:
	- set vid_width 800
	- set vid_height 600
	- set snd_output sdl (or alsa, oss)
	- setrom vid_render gl (or sw for software rendering)
	- setrom snd_render default (specially set jack here for JACK audio)"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -le 0.7.2-r1; then
		elog "Migration may be needed for ${PN}'s home paths, now using:"
		elog "    ~/.${PN}rc -> ~/.config/${PN}/${PN}.conf"
		elog "    ~/.${PN}/  -> ~/.local/share/${PN}/"
		elog "Also, nq-sdl / qw-client-sdl are no longer available (use -x11 instead)."
	fi
}
