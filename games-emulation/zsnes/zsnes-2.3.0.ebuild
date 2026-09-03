# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit flag-o-matic python-any-r1 toolchain-funcs xdg

DESCRIPTION="Fork of the classic Super Nintendo emulator"
HOMEPAGE="https://github.com/xyproto/zsnes/ https://www.zsnes.com/"
SRC_URI="
	https://github.com/xyproto/zsnes/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ao custom-cflags pipewire"

RDEPEND="
	media-libs/libglvnd[X]
	media-libs/libpng:=
	media-libs/libsdl3[opengl]
	virtual/zlib:=
	ao? ( media-libs/libao )
	pipewire? (  media-video/pipewire:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gcc:*
	virtual/pkgconfig
	virtual/zlib:=
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-cc-quotes.patch
)

src_compile() {
	# the old fragile ASM is gone, but the new C code is currently fragile too
	if use !custom-cflags; then
		strip-flags
		append-cppflags -U_FORTIFY_SOURCE # to disable =3, Makefile enables =2

		# furthermore fails with -Werror=strict-aliasing+lto-type-mismatch
		# https://github.com/xyproto/zsnes/issues/59#issuecomment-5024118435
		append-cflags -fno-strict-aliasing
		filter-lto
	fi

	# formerly gcc was forced due to asm issues (bug #830491) but, even with it
	# gone, it currently segfaults if built with clang and needs looking into
	if tc-is-clang; then
		CC=${CHOST}-gcc
		strip-unsupported-flags
	fi

	tc-export CC PKG_CONFIG
	append-cflags ${CPPFLAGS}

	ZSNES_MAKEARGS=(
		{ARCH,HOST_OS}=LINUX
		HOST_CPU="${CHOST%%-*}"
		OPT_FLAGS=
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
