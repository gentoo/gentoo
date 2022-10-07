# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Easy to use, but yet powerful, API for all possible input sources"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libgii.html"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="X"

RDEPEND="
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXxf86dga-1.1.4
	)"
DEPEND="${RDEPEND}
	kernel_linux? ( >=sys-kernel/linux-headers-2.6.11 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0-linux26-headers.patch
	"${FILESDIR}"/${P}-configure-cpuid-pic.patch
	"${FILESDIR}"/${P}-libtool_1.5_compat.patch
)

src_prepare() {
	default

	rm -f acinclude.m4 m4/libtool.m4 m4/lt*.m4 || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with X x)
		$(use_enable X x)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc ChangeLog.1999

	find "${ED}" -name '*.la' -delete || die
}
