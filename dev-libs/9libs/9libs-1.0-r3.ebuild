# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A package of Plan 9 compatibility libraries"
HOMEPAGE="https://www.netlib.org/research/9libs/9libs-1.0.README"
SRC_URI="https://www.netlib.org/research/9libs/${P}.tar.bz2"

LICENSE="PLAN9"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# Bug 385387
	epatch "${FILESDIR}/${PN}-va_list.patch"
}

src_configure() {
	tc-export CC
	econf \
		--includedir=/usr/include/9libs \
		--enable-shared
}

src_install() {
	make install DESTDIR="${D}"
	dodoc README

	# rename some man pages to avoid collisions with dev-libs/libevent
	local f
	for f in add balloc bitblt cachechars event frame graphics rgbpix; do
		mv "${D}"/usr/share/man/man3/${f}.{3,3g} || die
	done
}
