# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="DTS Coherent Acoustics audio encoder"
HOMEPAGE="https://aepatrakov.narod.ru/index/0-2
https://gitlab.com/patrakov/dcaenc"
SRC_URI="https://aepatrakov.narod.ru/olderfiles/1/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

RDEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable alsa)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}
