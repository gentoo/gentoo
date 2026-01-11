# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

# See model_version
MODEL_VERSION="0b50c45"

DESCRIPTION="Recurrent neural network for audio noise reduction"
HOMEPAGE="https://jmvalin.ca/demo/rnnoise/ https://gitlab.xiph.org/xiph/rnnoise"
SRC_URI="
	https://gitlab.xiph.org/xiph/rnnoise/-/archive/v${PV}/rnnoise-v${PV}.tar.bz2
	https://media.xiph.org/rnnoise/models/rnnoise_data-${MODEL_VERSION}.tar.gz
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="examples"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2-configure-clang16.patch
)

src_unpack() {
	unpack rnnoise-v${PV}.tar.bz2
	pushd "${S}" >/dev/null
	unpack rnnoise_data-${MODEL_VERSION}.tar.gz
	popd >/dev/null
}

src_prepare() {
	# Sanity check model version
	if [[ $(cat model_version) != ${MODEL_VERSION} ]]; then
		die "Model version ${MODEL_VERSION} doesn't match upstream $(cat model_version)"
	fi

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable examples)
		--disable-doc # doesn't include anything
		--disable-x86-rtcd # not so runtime cpu detection
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use examples && dobin examples/.libs/rnnoise_demo
	find "${ED}" -name '*.la' -delete || die
}
