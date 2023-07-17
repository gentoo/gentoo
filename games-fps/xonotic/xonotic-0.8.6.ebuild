# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop check-reqs toolchain-funcs xdg

DESCRIPTION="Fork of Nexuiz, Deathmatch FPS based on DarkPlaces, an advanced Quake 1 engine"
HOMEPAGE="https://xonotic.org/"
SRC_URI="https://dl.xonotic.org/${P}.zip"
S="${WORKDIR}/${PN^}"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="X +alsa ode +sdl"

# note: many dependencies are used through dlopen()
COMMON_UIDEPEND="
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis"
RDEPEND="
	dev-libs/d0_blind_id
	media-libs/libjpeg-turbo:=
	media-libs/libpng
	media-libs/freetype:2
	net-misc/curl
	sys-libs/zlib:=
	X? (
		${COMMON_UIDEPEND}
		media-libs/libglvnd[X]
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXxf86vm
		alsa? ( media-libs/alsa-lib )
	)
	ode? ( dev-games/ode:=[double-precision] )
	sdl? (
		${COMMON_UIDEPEND}
		media-libs/libsdl2[joystick,opengl,sound,video]
	)"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="app-arch/unzip"

CHECKREQS_DISK_BUILD="1500M"
CHECKREQS_DISK_USR="1200M"

src_prepare() {
	default

	sed -e 's|-O3 ||' \
		-e '/^LDFLAGS_RELEASE/s/$(OPTIM_RELEASE)/$(GENTOO_LDFLAGS)/' \
		-i source/darkplaces/makefile.inc || die
}

src_compile() {
	tc-export CC

	local emakeargs=(
		-C source/darkplaces
		DEFAULT_SNDAPI=$(usex alsa ALSA OSS)
		DP_FS_BASEDIR="${EPREFIX}"/usr/share/${PN}
		DP_LINK_ODE=$(usex ode shared no)
		STRIP=:
		CPUOPTIMIZATIONS="${CFLAGS}"
		GENTOO_LDFLAGS="${LDFLAGS}"
	)

	# split for bug 473352
	emake "${emakeargs[@]}" sv-release
	use X && emake "${emakeargs[@]}" cl-release
	use sdl && emake "${emakeargs[@]}" sdl-release
}

src_install() {
	newbin {source/darkplaces/darkplaces,${PN}}-dedicated

	if use X || use sdl; then
		if use X; then
			newbin {source/darkplaces/darkplaces,${PN}}-glx
			domenu misc/logos/${PN}-glx.desktop
		fi
		if use sdl; then
			newbin {source/darkplaces/darkplaces,${PN}}-sdl
			domenu misc/logos/${PN}.desktop
		fi

		local size
		for size in 16 22 24 32 48 128 256 512; do
			newicon -s ${size} misc/logos/icons_png/${PN}_${size}.png ${PN}.png
		done
		newicon -s scalable misc/logos/${PN}_icon.svg ${PN}.svg
	fi

	dodoc Docs/*.{md,txt}

	insinto /usr/share/${PN}
	doins -r key_0.d0pk server data

	rm "${ED}"/usr/share/${PN}/server/.gitattributes || die
}
