# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="A package of Plan 9 compatibility libraries"
HOMEPAGE="https://www.netlib.org/research/9libs/9libs-1.0.README"
SRC_URI="https://www.netlib.org/research/9libs/${P}.tar.bz2"

LICENSE="PLAN9"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND="
	>=x11-libs/libX11-1.0.0[static-libs?]
	>=x11-libs/libXt-1.0.0[static-libs?]
"
RDEPEND="
	${DEPEND}
"
DOCS=(
	README
)
PATCHES=(
	"${FILESDIR}"/${PN}-va_list.patch # Bug 385387
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		$(use_enable static-libs static) \
		--enable-shared \
		--includedir=/usr/include/9libs \
		--with-x
}

src_install() {
	default

	# rename some man pages to avoid collisions with dev-libs/libevent
	local f
	for f in add balloc bitblt cachechars event frame graphics rgbpix; do
		mv "${D}"/usr/share/man/man3/${f}.{3,3g} || die
	done

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
