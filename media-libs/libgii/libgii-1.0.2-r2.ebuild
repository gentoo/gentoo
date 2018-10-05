# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Easy to use, but yet powerful, API for all possible input sources"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libgii.html"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="X"

RDEPEND="
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86dga-1.1.4[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	kernel_linux? ( >=sys-kernel/linux-headers-2.6.11 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0-linux26-headers.patch
	"${FILESDIR}"/${P}-configure-cpuid-pic.patch
	"${FILESDIR}"/${P}-libtool_1.5_compat.patch
)

DOCS=( ChangeLog ChangeLog.1999 FAQ NEWS README )

MULTILIB_WRAPPED_HEADERS=( /usr/include/ggi/system.h )

src_prepare() {
	default
	rm -f acinclude.m4 m4/libtool.m4 m4/lt*.m4
	AT_M4DIR=m4 eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_with X x)
		$(use_enable X x)
		--disable-static
	)
	econf ${myeconfargs[@]}
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
