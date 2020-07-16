# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils desktop

DESCRIPTION="cross-platform multimedia library"
HOMEPAGE="https://liballeg.org/"
SRC_URI="mirror://sourceforge/alleg/${P}.tar.gz"

LICENSE="Allegro MIT GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~mips ppc ppc64 x86"
IUSE="alsa fbcon jack jpeg opengl oss png svga test vga vorbis X"
RESTRICT="!test? ( test )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	svga? ( media-libs/svgalib )
	vorbis? ( media-libs/libvorbis )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
		opengl? (
			virtual/glu
			virtual/opengl
		)
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${P}-shared.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-rpath.patch
	"${FILESDIR}"/${P}-Werror-format-security.patch # bug 540470
	"${FILESDIR}"/${P}-glibc228.patch               # bug 670781
	"${FILESDIR}"/${P}-GLX_RGBA_FLOAT_BIT.patch     # bug 672858
	"${FILESDIR}"/${P}-static-func.patch            # bug 696034
)

src_prepare() {
	cmake-utils_src_prepare

	sed -i \
		-e "s:allegro-\${ALLEGRO_VERSION}:${PF}:" \
		docs/CMakeLists.txt || die
}

src_configure() {
	# WANT_LINUX_CONSOLE is by default OFF
	# WANT_EXAMPLES doesn't install anything
	local mycmakeargs=(
		-DDOCDIR=share/doc
		-DMANDIR=share/man
		-DWANT_ALSA=$(usex alsa)
		-DWANT_DOCS_INFO=OFF
		-DWANT_EXAMPLES=OFF
		-DWANT_JACK=$(usex jack)
		-DWANT_JPGALLEG=$(usex jpeg)
		-DWANT_LINUX_CONSOLE=OFF
		-DWANT_LINUX_FBCON=$(usex fbcon)
		-DWANT_LINUX_SVGALIB=$(usex svga)
		-DWANT_LINUX_VGA=$(usex vga)
		-DWANT_LOADPNG=$(usex png)
		-DWANT_LOGG=$(usex vorbis)
		-DWANT_OSS=$(usex oss)
		-DWANT_TESTS=$(usex test)
		-DWANT_TOOLS=$(usex X)
		-DWANT_X11=$(usex X)
	)

	if use X; then
		mycmakeargs+=( -DWANT_ALLEGROGL=$(usex opengl) )
	else
		mycmakeargs+=( -DWANT_ALLEGROGL=OFF )
	fi

	cmake-utils_src_configure
}

src_install() {
	rm -r docs/html/{build,tmpfile.txt} || die
	local HTML_DOCS=( docs/html/. )

	cmake-utils_src_install

	#176020 (init_dialog.3), #409305 (key.3)
	pushd docs/man >/dev/null
	local manpage
	for manpage in $(ls -d *.3); do
		newman ${manpage} ${PN}-${manpage}
	done
	popd >/dev/null

	if use X; then
		newbin setup/setup ${PN}-setup
		insinto /usr/share/${PN}
		doins {keyboard,language,setup/setup}.dat
		newicon misc/icon.png ${PN}.png
		make_desktop_entry ${PN}-setup "Allegro Setup" ${PN} "Settings"
	fi
}
