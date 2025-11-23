# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="DTS Coherent Acoustics audio encoder"
HOMEPAGE="https://gitlab.com/patrakov/dcaenc"
SRC_URI="https://gitlab.com/patrakov/dcaenc/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

RDEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable alsa)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
	if use alsa; then
		dosym ../../../usr/share/alsa/pcm/dca.conf \
				/etc/alsa/conf.d/dca.conf
	fi
}
