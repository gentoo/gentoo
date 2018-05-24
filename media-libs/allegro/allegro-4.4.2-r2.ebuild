# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-multilib

DESCRIPTION="cross-platform multimedia library"
HOMEPAGE="http://alleg.sourceforge.net/"
SRC_URI="mirror://sourceforge/alleg/${P}.tar.gz"

LICENSE="Allegro MIT GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE="alsa fbcon jack jpeg opengl oss png svga test vga vorbis X"

RDEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	svga? ( media-libs/svgalib[${MULTILIB_USEDEP}] )
	vorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXpm[${MULTILIB_USEDEP}]
		x11-libs/libXt[${MULTILIB_USEDEP}]
		x11-libs/libXxf86dga[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		opengl? (
			virtual/glu
			virtual/opengl
		)
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${P}-r2-shared.patch
	"${FILESDIR}"/${P}-r2-underlink.patch
	"${FILESDIR}"/${P}-r2-gentoo.patch
	"${FILESDIR}"/${P}-r2-rpath.patch
	"${FILESDIR}"/${P}-Werror-format-security.patch
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

	mycmakeargs=(
		-DDOCDIR=share/doc
		-DINFODIR=share/info
		-DMANDIR=share/man
		-DWANT_ALSA=$(usex alsa)
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
		mycmakeargs+=( -DWANT_ALLEGROGL=OFF	)
	fi

	cmake-multilib_src_configure
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		dodoc -r docs/html/*.html
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
			doins "${S}"/{keyboard,language,setup/setup}.dat
			newicon "${S}"/misc/icon.png ${PN}.png
			make_desktop_entry ${PN}-setup "Allegro Setup" ${PN} "Settings"
		fi
	fi
	cmake-utils_src_install
}
