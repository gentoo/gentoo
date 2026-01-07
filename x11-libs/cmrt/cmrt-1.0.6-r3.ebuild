# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Intel C for Media RunTime GPU kernel manager"
HOMEPAGE="https://github.com/intel/cmrt"
SRC_URI="https://github.com/intel/cmrt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=x11-libs/libdrm-2.4.23[video_cards_intel]
	>=media-libs/libva-2.0.0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-musl-fix.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/864409
	#
	#  > Intel has ceased development and contributions including, but not
	#  > limited to, maintenance, bug fixes, new releases, or updates, to this
	#  > project. Intel no longer accepts patches to this project.
	# No point in submitting a bug report or trying to get this into good shape.
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	default
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
