# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="https://wiki.xiph.org/index.php/OggKate https://gitlab.xiph.org/xiph/kate"
SRC_URI="https://downloads.xiph.org/releases/kate/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug"

RDEPEND="
	media-libs/libogg[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.3-fix_overflow_tests.patch
)

multilib_src_configure() {
	# preliminary check with hardcoded pkg-config
	# then PKG_PROG_PKG_CONFIG from aclocal.m4 correctly handles PKG_CONFIG
	export ac_cv_prog_HAVE_PKG_CONFIG=yes

	local ECONF_SOURCE="${S}"

	local myeconfargs=(
		$(use_enable debug)
		PYTHON=:
	)
	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
