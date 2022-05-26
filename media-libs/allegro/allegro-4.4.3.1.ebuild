# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib desktop

DESCRIPTION="cross-platform multimedia library"
HOMEPAGE="https://liballeg.org/"
SRC_URI="https://github.com/liballeg/allegro5/releases/download/${PV}/${P}.tar.gz"

LICENSE="Allegro MIT GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~mips ppc ppc64 ~riscv x86"
IUSE="alsa doc fbcon jack jpeg opengl oss png svga vga vorbis X"

RDEPEND="
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
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
			virtual/glu[${MULTILIB_USEDEP}]
			virtual/opengl[${MULTILIB_USEDEP}]
		)
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	doc? ( sys-apps/texinfo )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.4.2-shared.patch
	"${FILESDIR}"/${PN}-4.4.2-underlink.patch
	"${FILESDIR}"/${PN}-4.4.2-gentoo.patch
	"${FILESDIR}"/${PN}-4.4.2-rpath.patch
	"${FILESDIR}"/${PN}-4.4.3.1-texinfo-encoding.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i \
		-e "s:allegro-\${ALLEGRO_VERSION}:${PF}:" \
		docs/CMakeLists.txt || die
}

src_configure() {
	# WANT_LINUX_CONSOLE is by default OFF
	# WANT_EXAMPLES doesn't install anything
	# WANT_TEST doesn't do anything regarding unittests
	local mycmakeargs=(
		-DDOCDIR=share/doc
		-DINFODIR=share/info
		-DMANDIR=share/man
		-DWANT_ALSA=$(usex alsa)
		-DWANT_DOCS_INFO=$(usex doc)
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
		-DWANT_TESTS=OFF
		-DWANT_TOOLS=$(usex X)
		-DWANT_X11=$(usex X)
	)

	if use X; then
		mycmakeargs+=( -DWANT_ALLEGROGL=$(usex opengl) )
	else
		mycmakeargs+=( -DWANT_ALLEGROGL=OFF )
	fi

	cmake-multilib_src_configure
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		dodoc -r docs/html
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
	cmake_src_install
}
