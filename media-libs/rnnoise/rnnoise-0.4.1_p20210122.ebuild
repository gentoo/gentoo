# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Recurrent neural network for audio noise reduction"
HOMEPAGE="https://jmvalin.ca/demo/rnnoise/ https://gitlab.xiph.org/xiph/rnnoise"

COMMIT="1cbdbcf1283499bbb2230a6b0f126eb9b236defd"
SRC_URI="https://gitlab.xiph.org/xiph/rnnoise/-/archive/${COMMIT}/rnnoise-${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE="doc"
# NOTE: Documentation currently empty (version 0.4.1_p20210122)

BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--disable-examples
		$(use_enable doc)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	rm "${ED}/usr/share/doc/${PF}/COPYING" || die
	find "${ED}" -name '*.la' -delete || die
}
