# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse2 debug openmp"

PATCHES=(
	"${FILESDIR}"/libimagequant-2.12.2-respect-CFLAGS.patch
	"${FILESDIR}"/libimagequant-2.12.2-fix-pkgconfig.patch
	"${FILESDIR}"/libimagequant-2.14.0-fix-openmp-pragma.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	sed -i '/install.*STATICLIB/d' Makefile || die
}

src_configure() {
	tc-export AR CC
	# Hand rolled configure script, so not all flags are supported.
	./configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		$(use_enable debug) \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use_with openmp) \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}

src_compile() {
	emake shared imagequant.pc
}
