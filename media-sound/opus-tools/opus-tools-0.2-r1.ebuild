# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Royalty-free, highly versatile audio codec"
HOMEPAGE="https://opus-codec.org/"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.xiph.org/opus-tools.git"
elif [[ ${PV%_p*} != ${PV} ]] ; then # Gentoo snapshot
	SRC_URI="https://dev.gentoo.org/~lu_zero/${PN}/${P}.tar.xz"
else # Official release
	SRC_URI="https://downloads.xiph.org/releases/opus/${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"
IUSE="flac"

RDEPEND="
	>=media-libs/libogg-1.3.0
	>=media-libs/libopusenc-0.2
	>=media-libs/opus-1.1
	>=media-libs/opusfile-0.5
	flac? ( >=media-libs/flac-1.1.3:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	econf $(use_with flac)
}

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
