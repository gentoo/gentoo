# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Recurrent neural network for audio noise reduction"
HOMEPAGE="https://jmvalin.ca/demo/rnnoise/ https://gitlab.xiph.org/xiph/rnnoise"

MY_PV="70f1d256acd4b34a572f999a05c87bf00b67730d"
MODEL_PV="0a8755f8e2d834eff6a54714ecc7d75f9932e845df35f8b59bc52a7cfe6e8b37"
SRC_URI="https://gitlab.xiph.org/xiph/rnnoise/-/archive/${MY_PV}/rnnoise-${MY_PV}.tar.bz2 -> ${P}.tar.bz2
	https://media.xiph.org/rnnoise/models/rnnoise_data-${MODEL_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0/0.4.1"  # TODO: this is the .so version, PV should match tag version instead.
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc examples cpu_flags_x86_avx2 cpu_flags_x86_sse4_1"

BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

src_unpack() {
	unpack "${P}.tar.bz2"
	cd "${S}" || die
	[[ "$(cat model_version)" = "${MODEL_PV}" ]] || \
		die "Model version mismatch, new version: $(cat model_version)"
	unpack "rnnoise_data-${MODEL_PV}.tar.gz"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable examples)
		$(use_enable $(usex cpu_flags_x86_{avx2,sse4_1,avx2}) x86-rtcd)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use examples && dobin examples/.libs/rnnoise_demo

	rm "${ED}/usr/share/doc/${PF}/COPYING" || die
	find "${ED}" -name '*.la' -delete || die
}
