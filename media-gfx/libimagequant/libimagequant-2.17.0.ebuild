# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse2 openmp"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12.2-respect-CFLAGS.patch
	"${FILESDIR}"/${PN}-2.15.1-fix-pkgconfig.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	# Avoid always building static library
	# (Fixes side-effect of compiling in src_install too)
	sed -i \
		-e '/install.*STATICLIB/d' \
		-e 's/all: static shared/all: shared/' \
		Makefile || die
}

src_configure() {
	tc-export AR CC

	# Hand rolled configure script, so not all flags are supported.
	./configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use_with openmp) \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}

src_compile() {
	emake shared imagequant.pc
}
