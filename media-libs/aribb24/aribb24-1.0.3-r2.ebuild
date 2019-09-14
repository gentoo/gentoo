# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library for decoding ARIB STD-B24 subtitles"
HOMEPAGE="https://github.com/nkoriyama/aribb24"
SRC_URI="https://github.com/nkoriyama/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="media-libs/libpng:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-reset-control_time.patch
	"${FILESDIR}"/${P}-fix-default-macros.patch
	"${FILESDIR}"/${P}-add-missing-curly-braces.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
}
