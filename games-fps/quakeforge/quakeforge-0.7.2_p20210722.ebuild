# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1 toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/quakeforge/quakeforge.git"
else
	MY_COMMIT="e799a7ae45b0ab2ad7b642953277db8ccf256cf8"
	SRC_URI="https://github.com/quakeforge/quakeforge/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="3D engine based on id Software's Quake and QuakeWorld game engines"
HOMEPAGE="http://www.quakeforge.net/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="alsa +client debug doc flac jack ncurses oss png sdl vorbis vulkan wildmidi zlib"

RDEPEND="
	client? (
		media-libs/libsamplerate
		net-misc/curl
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		alsa? ( media-libs/alsa-lib )
		flac? ( media-libs/flac )
		jack? ( virtual/jack )
		sdl? ( media-libs/libsdl[sound] )
		vorbis? ( media-libs/libvorbis )
		vulkan? ( media-libs/vulkan-loader )
		wildmidi? ( media-sound/wildmidi )
	)
	ncurses? ( sys-libs/ncurses:= )
	png? ( media-libs/libpng:= )
	zlib? ( sys-libs/zlib:= )"
DEPEND="
	${RDEPEND}
	client? (
		x11-base/xorg-proto
		vulkan? ( dev-util/vulkan-headers )
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
	"${FILESDIR}"/${P}-skipped-tests.patch
)

src_prepare() {
	default

	echo ${PV} > .tarball-version || die
	eautoreconf
}

src_configure() {
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
		$(qf_client vulkan)
		$(qf_client wildmidi)
		$(use_enable client sound)
		$(use_enable client vidmode)
		$(use_enable debug)
		$(use_enable ncurses curses)
		$(use_enable png)
		$(use_enable zlib)
		$(use_with client x)
		--disable-Werror
		--disable-dga
		--enable-xdg
		# non-x11 clients are mostly abandoned/broken (SDL1 still useful for pulseaudio)
		--with-clients=$(usev client x11)
		--with-cpp="$(tc-getCPP) -x c %u %d %s -o %o %i" # see config.d/qfcc.m4
		--with-global-cfg="${EPREFIX}"/etc/quakeforge.conf
		--with-sharepath="${EPREFIX}"/usr/share/quake1
	)

	econf "${econfargs[@]}"
}

src_compile() {
	default

	use doc && emake doc
}

src_install() {
	use doc && local HTML_DOCS=( doxygen/html/. )

	emake -j1 DESTDIR="${D}" install
	einstalldocs

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
	- set snd_output sdl (or alsa, jack, oss -- sdl can do pulseaudio)
	- setrom vid_render gl (or vulkan, sw for software rendering)"
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

	if use vulkan; then
		ewarn "You've enabled the new vulkan support that is still experimental and yet"
		ewarn "used by default. If have issues, can use '+setrom vid_render gl' command"
		ewarn "line option to revert to GL."
	fi
}
