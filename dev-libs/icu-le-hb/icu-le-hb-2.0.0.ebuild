# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="ICU Layout Engine API on top of HarfBuzz shaping library"
HOMEPAGE="https://github.com/harfbuzz/harfbuzz https://github.com/harfbuzz/icu-le-hb"
SRC_URI="https://github.com/harfbuzz/icu-le-hb/releases/download/${PV}/${P}.tar.gz"

LICENSE="icu"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ppc ~ppc64 sparc x86"

# dev-libs/icu is not linked into icu-le-hb but the latter still needs
# to be rebuilt on dev-libs/icu upgrades (see bug #621786).
RDEPEND="
	dev-libs/icu:=[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
}
