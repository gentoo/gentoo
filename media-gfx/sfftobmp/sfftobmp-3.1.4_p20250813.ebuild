# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="sff to bmp converter"
HOMEPAGE="https://github.com/Sonderstorch/sfftools"

# no up-to-date releases or tags
COMMIT="7f7b11dd4b290e135a16c2972457d09ad843ff67"
SRC_URI="https://github.com/Sonderstorch/sfftools/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/sfftools-${COMMIT}/sfftobmp3/trunk"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

RDEPEND="
	dev-libs/boost:=
	media-libs/libjpeg-turbo:=
	media-libs/tiff:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.4-boost-1.89.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc doc/{changes,credits,readme}
}
