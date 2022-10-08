# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Plan 9 compatibility libraries"
HOMEPAGE="https://netlib.org/research/9libs/9libs-1.0.README"
SRC_URI="https://netlib.org/research/9libs/${P}.tar.bz2"

LICENSE="PLAN9"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
RESTRICT="test" # interactive, hangs with virtx and fails without (bug #403539)

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt"
DEPEND="
	${DEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PN}-va_list.patch # Bug 385387
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing #855665

	local econfargs=(
		--enable-shared
		--includedir="${EPREFIX}"/usr/include/9libs
		--with-x
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	# rename some man pages to avoid collisions with dev-libs/libevent
	local f
	for f in add balloc bitblt cachechars event frame graphics rgbpix; do
		mv "${ED}"/usr/share/man/man3/${f}.{3,3g} || die
	done

	find "${ED}" -type f -name '*.la' -delete || die
}
