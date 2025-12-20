# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool

DESCRIPTION="Library for manipulating FlashPIX images"
HOMEPAGE="https://github.com/ImageMagick/libfpx"
SRC_URI="mirror://imagemagick/delegates/${P/_p/-}.tar.bz2"
S="${WORKDIR}/${P/_p/-}"

LICENSE="Flashpix"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0.13-export-symbols.patch
	"${FILESDIR}"/${PN}-1.3.1_p10-musl-1.2.3-null.patch
)

src_prepare() {
	default

	# we're not windows, even though we don't define __unix by default
	[[ ${CHOST} == *-darwin* ]] && append-flags -D__unix

	elibtoolize
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859913
	# https://github.com/ImageMagick/libfpx/issues/6
	#
	# Do not trust for LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	# https://bugs.gentoo.org/896246
	# already fixed by upstream but the patch is too large, waiting for new releases
	# https://github.com/ImageMagick/libfpx/commit/5f340b0a490450b40302cc9948c7dfac60d40041
	append-cxxflags -std=gnu++14

	append-ldflags -Wl,--no-undefined
	econf \
		$(use_enable static-libs static) \
		LIBS="-lstdc++ -lm"
}

src_install() {
	default

	# bug 847412
	if ! use static-libs; then
		find "${ED}" -type f -name '*.la' -delete || die
	fi

	dodoc AUTHORS ChangeLog doc/*.txt

	docinto pdf
	dodoc doc/*.pdf
	docompress -x /usr/share/doc/${PF}/pdf
}
