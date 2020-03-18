# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic meson xdg

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="https://github.com/snes9xgit/snes9x"
SRC_URI="https://github.com/snes9xgit/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="alsa debug gtk multilib netplay opengl oss png pulseaudio portaudio wayland xinerama +xv"
RESTRICT="bindist"

RDEPEND="
	sys-libs/zlib:=[minizip]
	x11-libs/libX11
	x11-libs/libXext
	png? ( media-libs/libpng:0= )
	gtk? (
		dev-libs/glib:2
		media-libs/libsdl2[joystick]
		>=x11-libs/gtk+-3.22:3[wayland?]
		x11-libs/libXrandr
		x11-misc/xdg-utils
		alsa? ( media-libs/alsa-lib )
		opengl? (
			media-libs/libepoxy
			virtual/opengl
		)
		portaudio? ( >=media-libs/portaudio-19_pre )
		pulseaudio? ( media-sound/pulseaudio )
		xv? ( x11-libs/libXv )
		wayland? ( dev-libs/wayland )
	)
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}/unix"

PATCHES=(
	"${FILESDIR}"/${PN}-1.53-cross-compile.patch
	"${FILESDIR}"/${PN}-1.59-build-system.patch
)

src_prepare() {
	cd "${WORKDIR}/${P}" || die
	rm -r unzip || die
	default
	cd unix || die
	eautoreconf
	if use gtk ; then
		export EMESON_SOURCE="${WORKDIR}/${P}/gtk"
	fi
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack

	# build breaks when zlib/zip support is disabled
	local myeconfargs=(
		--enable-gamepad
		--enable-gzip
		--enable-zip
		--with-system-zip
		$(use_enable debug debugger)
		$(use_enable netplay)
		$(use_enable png screenshot)
		$(use_enable xinerama)
	)
	econf "${myeconfargs[@]}"

	if use gtk; then
		local emesonargs=(
			-Dalsa="$(usex alsa true false)"
			-Ddebugger="$(usex debug true false)"
			-Dgtk2=false
			-Dgtk3=true
			-Dopengl="$(usex opengl true false)"
			-Doss="$(usex oss true false)"
			-Dportaudio="$(usex portaudio true false)"
			-Dpulseaudio="$(usex pulseaudio true false)"
			-Dscreenshot="$(usex png true false)"
			-Dsystem-zip=true
			-Dxv="$(usex xv true false)"
			-Dzlib=true
			-Dwayland="$(usex wayland true false)"
		)
		meson_src_configure
	fi
}

src_compile() {
	emake
	use gtk && meson_src_compile
}

src_install() {
	dobin ${PN}

	dodoc ../docs/{changes,control-inputs,controls,snapshots}.txt
	dodoc snes9x.conf.default

	if use gtk ; then
		meson_src_install
		dodoc ../gtk/AUTHORS
	fi

	docinto html
	dodoc {.,..}/docs/*.html
}

pkg_preinst() {
	use gtk && xdg_pkg_preinst
}

pkg_postinst() {
	use gtk && xdg_pkg_postinst
}

pkg_postrm() {
	use gtk && xdg_pkg_postrm
}
