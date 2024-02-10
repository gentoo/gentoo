# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Blu-ray utilities: bluray_info, bluray_copy, bluray_player"
HOMEPAGE="https://github.com/beandog/bluray_info https://dvds.beandog.org"
SRC_URI="https://bluray.beandog.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mpv"

DEPEND="
	media-libs/libaacs
	>=media-libs/libbluray-1.2.0[aacs]
	mpv? ( media-video/mpv[libmpv,bluray] )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with mpv libmpv)
}
