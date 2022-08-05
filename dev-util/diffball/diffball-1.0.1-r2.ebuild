# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="https://github.com/zmedico/diffball"
SRC_URI="https://github.com/zmedico/diffball/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zmedico/diffball/pull/1.patch -> ${P}-bug_543310_stack_buffer_overflows.patch
	https://github.com/zmedico/diffball/pull/2.patch -> ${P}-bug_708736_cseek_xz_reset_avail_in_out.patch"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug"

RDEPEND="
	>=sys-libs/zlib-1.1.4
	>=app-arch/bzip2-1.0.2
	app-arch/xz-utils"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# Invalid RESTRICT for source package. Investigate.
RESTRICT="strip"

PATCHES=(
	"${DISTDIR}"/${P}-bug_543310_stack_buffer_overflows.patch
	"${DISTDIR}"/${P}-bug_708736_cseek_xz_reset_avail_in_out.patch
)

src_prepare() {
	# fix bug 548316 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug asserts)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
