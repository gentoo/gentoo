# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic multilib toolchain-funcs xdg

DESCRIPTION="Fork of the classic Super Nintendo emulator"
HOMEPAGE="https://github.com/xyproto/zsnes/ https://www.zsnes.com/"
SRC_URI="https://github.com/xyproto/zsnes/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="custom-cflags"

RDEPEND="
	media-libs/libglvnd[X,abi_x86_32(-)]
	media-libs/libpng:=[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-),joystick,opengl,sound,video]
	virtual/zlib:=[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	dev-lang/nasm
	virtual/zlib:=
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.9-cc-quotes.patch
	"${FILESDIR}"/${PN}-2.0.9-gentoo-zlib.patch
	"${FILESDIR}"/${P}-initc.patch
)

src_compile() {
	# Makefile forces many CFLAGS that are questionable, but zsnes' ancient x86
	# asm is fragile, not pic safe (bug #427104), broken by F_S=3 (formerly
	# broken with =2 as well), and can be affected by -march=* and similar.
	# Stick to upstream's choices, this is non-portable either way.
	if use !custom-cflags; then
		strip-flags
		append-cppflags -U_FORTIFY_SOURCE # to disable =3, Makefile enables =2
	fi

	# used to build and run parsegen at build time (uses zlib wrt BDEPEND)
	tc-export_build_env BUILD_CXX
	local buildcxx="${BUILD_CXX} ${BUILD_CXXFLAGS} ${BUILD_CPPFLAGS} ${BUILD_LDFLAGS}"

	use amd64 && multilib_toolchain_setup x86
	tc-export CC CXX
	append-cflags "${CPPFLAGS}"
	append-cxxflags "${CPPFLAGS}"

	emake CXX_HOST="${buildcxx}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	dodoc README.md TODO.md

	newicon icons/64x64x32.png ${PN}.png
	make_desktop_entry ${PN} ${PN^^}
}
