# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic multilib python-any-r1 toolchain-funcs xdg

DESCRIPTION="Fork of the classic Super Nintendo emulator"
HOMEPAGE="https://github.com/xyproto/zsnes/ https://www.zsnes.com/"
SRC_URI="
	https://github.com/xyproto/zsnes/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="ao custom-cflags pipewire"

RDEPEND="
	media-libs/libglvnd[X,abi_x86_32(-)]
	media-libs/libpng:=[abi_x86_32(-)]
	media-libs/libsdl3[abi_x86_32(-),opengl]
	virtual/zlib:=[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	ao? ( media-libs/libao[abi_x86_32(-)] )
	pipewire? (  media-video/pipewire:=[abi_x86_32(-)] )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/nasm
	virtual/pkgconfig
	virtual/zlib:=
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-cc-quotes.patch
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

	use amd64 && multilib_toolchain_setup x86
	tc-export CC CXX
	append-cflags ${CPPFLAGS}
	append-cxxflags ${CPPFLAGS}

	ZSNES_MAKEARGS=(
		ARCH=LINUX
		PREFIX="${EPREFIX}"/usr
		WITH_AO=$(usex ao)
		WITH_PIPEWIRE=$(usex pipewire)
	)

	emake "${ZSNES_MAKEARGS[@]}"
}

src_install() {
	emake "${ZSNES_MAKEARGS[@]}" DESTDIR="${D}" install
	einstalldocs
}
