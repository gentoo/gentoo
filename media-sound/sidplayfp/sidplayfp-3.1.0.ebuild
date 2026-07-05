# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Sidplay2 fork with resid-fp"
HOMEPAGE="https://github.com/libsidplayfp/sidplayfp"
SRC_URI="https://github.com/libsidplayfp/sidplayfp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/libfmt-11.0.0:=
	media-libs/libsidplayfp:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# PR pending https://github.com/libsidplayfp/sidplayfp/pull/135.patch
	"${FILESDIR}"/${PN}-3.1.0-unbundle_fmt.patch
)

src_prepare() {
	default

	# unbundle libfmt
	rm -r libs/fmt || die

	# for unbundled_fmt.patch
	eautoreconf
}

src_configure() {
	econf --with-system-fmt
}
