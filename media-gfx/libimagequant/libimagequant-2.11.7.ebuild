# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse2 debug openmp static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	tc-export AR CC
	# Hand rolled configure script, so not all flags are supported.
	./configure \
		--prefix="${EPREFIX}/usr" \
		$(use debug && echo --enable-debug) \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use_with openmp) \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_compile() {
	emake shared
	use static-libs && emake static
}

src_install() {
	dolib.so libimagequant.so
	dolib.so libimagequant.so.*
	use static-libs && dolib.a libimagequant.a
	doheader libimagequant.h
	einstalldocs
}
