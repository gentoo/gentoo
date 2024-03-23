# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="QR decoder library"
HOMEPAGE="https://github.com/dlbeer/quirc"

inherit flag-o-matic multilib-minimal toolchain-funcs

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dlbeer/${PN}.git"
else
	SRC_URI="
		https://github.com/dlbeer/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl:=
	opencv? ( media-libs/opencv:= )
	sdl? ( media-libs/sdl-gfx:= )
"
RDEPEND="
	${DEPEND}
"

LICENSE="ISC"
SLOT="0/${PV}"

IUSE="opencv sdl tools v4l"

src_prepare() {
	LIB_VERSION=$(grep '^LIB_VERSION = ' "${S}/Makefile" | cut -d ' ' -f 3 || die)
	sed -r \
		-e "s#\.o libquirc.a#.o libquirc.so.${LIB_VERSION}#g" \
		-e '/^QUIRC_CFLAGS/ s/$/ -fPIC/' \
		-i Makefile || die

	default
	multilib_copy_sources
}

multilib_src_configure() {
	tc-export CC CXX

	targets=( libquirc.so )
	use opencv && targets+=( opencv )
	use sdl && targets+=( sdl )
	use tools && targets+=( qrtest )
	use v4l && targets+=( v4l )
}

multilib_src_compile() {
	append-ldflags "-Wl,-soname,lib${QUIRC}.so.${LIB_VERSION}"
	emake V=1 DESTDIR="${D}" PREFIX="${EPREFIX}/usr" "${targets[@]}"
}

multilib_src_install() {
	dolib.so "libquirc.so.${LIB_VERSION}"
	dosym "libquirc.so.${LIB_VERSION}" "${EPREFIX}/usr/$(get_libdir)/libquirc.so"
	dosym "libquirc.so.${LIB_VERSION}" "${EPREFIX}/usr/$(get_libdir)/libquirc.so.$(ver_cut 1 LIB_VERSION)"

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
