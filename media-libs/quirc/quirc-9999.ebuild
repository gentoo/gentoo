# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="QR decoder library"
HOMEPAGE="https://github.com/dlbeer/quirc"

inherit flag-o-matic multilib-minimal toolchain-funcs

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dlbeer/${PN}.git"
else
	SRC_URI="
		https://github.com/dlbeer/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DEPEND="
	opencv? (
		media-libs/libjpeg-turbo:=
		media-libs/libpng:=
		media-libs/opencv:=
	)
	sdl? (
		media-libs/libjpeg-turbo:=
		media-libs/libpng:=
		media-libs/libsdl:=
		media-libs/sdl-gfx:=
	)
	tools? (
		media-libs/libjpeg-turbo:=
		media-libs/libpng:=
	)
	v4l? (
		media-libs/libjpeg-turbo:=
	)
"
RDEPEND="
	${DEPEND}
"

LICENSE="ISC"
SLOT="0/${PV}"

IUSE="opencv sdl tools v4l"

PATCHES=(
	"${FILESDIR}/quirc-1.2-allow-sdl-less-build.patch"
)

src_prepare() {
	read -r LIB_VERSION <<< "$(grep '^LIB_VERSION = ' "${S}/Makefile" | cut -d ' ' -f 3 || die)"
	export LIB_VERSION

	sed -r \
		-e "s#\.o libquirc.a#.o libquirc.so.${LIB_VERSION}#g" \
		-e '/^QUIRC_CFLAGS/ s/$/ -fPIC/' \
		-i Makefile || die

	default

	multilib_copy_sources
}

multilib_src_configure() {
	tc-export CC CXX
}

multilib_src_compile() {
	append-ldflags "-Wl,-soname,libquirc.so.${LIB_VERSION}"

	local targets=( "libquirc.so" )

	if multilib_is_native_abi; then
		if use opencv; then
			targets+=( "opencv" )
		fi

		if use sdl; then
			targets+=( "sdl" )
		fi

		if use tools; then
			targets+=( "qrtest" )
		fi

		if use v4l; then
			targets+=( "v4l" )
		fi
	fi

	emake V=1 DESTDIR="${D}" PREFIX="${EPREFIX}/usr" "${targets[@]}"
}

multilib_src_install() {
	dolib.so "libquirc.so.${LIB_VERSION}"

	dosym "libquirc.so.${LIB_VERSION}" "${EPREFIX}/usr/$(get_libdir)/libquirc.so"
	dosym "libquirc.so.${LIB_VERSION}" "${EPREFIX}/usr/$(get_libdir)/libquirc.so.$(ver_cut 1 "${LIB_VERSION}")"

	if multilib_is_native_abi; then
		into "/usr/libexec/${PN}"

		if use opencv; then
			dobin inspect-opencv
			dobin quirc-demo-opencv
		fi

		if use sdl; then
			dobin inspect
			dobin quirc-demo
		fi

		if use tools; then
			dobin qrtest
		fi

		if use v4l; then
			dobin quirc-scanner
		fi
	fi
}

multilib_src_install_all() {
	doheader lib/quirc.h
}
