# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit font python-any-r1

DESCRIPTION="Google Noto Emoji fonts"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-emoji"

COMMIT="ac1703e9d7feebbf5443a986e08332b1e1c5afcf"
SRC_URI="https://github.com/googlei18n/noto-emoji/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}
	app-arch/zopfli
	$(python_gen_any_dep '
		dev-python/fonttools[${PYTHON_USEDEP}]
		dev-python/nototools[${PYTHON_USEDEP}]
	')
	media-gfx/pngquant
	x11-libs/cairo
	|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[png] )
"
RDEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

FONT_S="${S}"
FONT_SUFFIX="ttf"

python_check_deps() {
	has_version "dev-python/fonttools[${PYTHON_USEDEP}]" && \
        has_version "dev-python/nototools[${PYTHON_USEDEP}]"
}

PATCHES=(
	# From Fedora
	"${FILESDIR}/${PN}-build-all-flags.patch"

	# https://github.com/googlei18n/noto-emoji/issues/240
	"${FILESDIR}/${PN}-20180823-build-path.patch"
)

src_prepare() {
	default

	# Based on Fedora patch to allow graphicsmagick usage
	if has_version media-gfx/graphicsmagick; then
		eapply "${FILESDIR}/${PN}-20190328-use-gm.patch"
	fi
}

src_install() {
	font_src_install

	# Don't lose fancy emoji icons
	insinto /usr/share/icons/"${PN}"/128x128/emotes/
	doins png/128/*.png

	insinto /usr/share/icons/"${PN}"/scalable/emotes/
	doins svg/*.svg
}
