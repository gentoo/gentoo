# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit font python-any-r1

DESCRIPTION="Google Noto Emoji fonts"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlefonts/noto-emoji"

COMMIT="ac1703e9d7feebbf5443a986e08332b1e1c5afcf"
SRC_URI="https://github.com/googlefonts/noto-emoji/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="buildfont"

BDEPEND="
	buildfont? (
		${PYTHON_DEPS}
		app-arch/zopfli
		$(python_gen_any_dep '
			dev-python/fonttools[${PYTHON_USEDEP}]
			dev-python/nototools[${PYTHON_USEDEP}]
		')
		media-gfx/pngquant
		x11-libs/cairo
		|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[png] )
	)
"

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

python_check_deps() {
	has_version -b "dev-python/fonttools[${PYTHON_USEDEP}]" &&
	has_version -b "dev-python/nototools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	font_pkg_setup
}

src_prepare() {
	default

	if use buildfont; then
		# From Fedora
		eapply "${FILESDIR}/${PN}-build-all-flags.patch"

		# https://github.com/googlei18n/noto-emoji/issues/240
		eapply "${FILESDIR}/${PN}-20180823-build-path.patch"

		# Be more verbose, bug #717654
		eapply "${FILESDIR}"/${PN}-pngquant-verbose.patch
		eapply "${FILESDIR}"/${PN}-zopflipng-verbose.patch

		# Based on Fedora patch to allow graphicsmagick usage
		if has_version -b media-gfx/graphicsmagick; then
			eapply "${FILESDIR}/${PN}-20190328-use-gm.patch"
		fi
	fi
}

src_compile() {
	if ! use buildfont; then
		einfo "Installing pre-built fonts provided by upstream."
		einfo "They could be not fully updated or miss some items."
		einfo "To build fonts based on latest images enable 'buildfont'"
		einfo "USE (that will require more time and resources too)."
	else
		python_setup
		einfo "Building fonts..."
		default
	fi
}

src_install() {
	if ! use buildfont; then
		FONT_S="${S}/fonts"
	else
		mv -i fonts/NotoEmoji-Regular.ttf "${S}" || die
		# Built font and Regular font
		FONT_S="${S}"

		# Don't lose fancy emoji icons
		insinto /usr/share/icons/"${PN}"/128x128/emotes/
		doins png/128/*.png

		insinto /usr/share/icons/"${PN}"/scalable/emotes/
		doins svg/*.svg
	fi

	FONT_SUFFIX="ttf"
	font_src_install

	dodoc README.md
}
