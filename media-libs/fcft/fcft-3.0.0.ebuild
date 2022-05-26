# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit meson python-any-r1

DESCRIPTION="Simple library for font loading and glyph rasterization"
HOMEPAGE="https://codeberg.org/dnkl/fcft"
SRC_URI="https://codeberg.org/dnkl/fcft/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples +harfbuzz +libutf8proc test"
REQUIRED_USE="
	libutf8proc? ( harfbuzz )
	examples? ( libutf8proc )
"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	examples? (
		dev-libs/libutf8proc:=
		dev-libs/wayland
	)
	harfbuzz? (
		media-libs/harfbuzz:=
	)
	libutf8proc? (
		dev-libs/libutf8proc:=
	)
"
DEPEND="
	${RDEPEND}
	app-i18n/unicode-data
	dev-libs/tllist
	examples? (
		dev-libs/wayland-protocols
	)
	test? (
		dev-libs/check
		harfbuzz? ( media-fonts/noto-emoji )
	)
"
BDEPEND="
	${PYTHON_DEPS}
	app-text/scdoc
	examples? (
		dev-util/wayland-scanner
	)
"

src_prepare() {
	default

	rm -r unicode || die "Failed removing vendored unicode-data"

	sed -i "s;unicode/UnicodeData.txt;${EPREFIX}/usr/share/unicode-data/UnicodeData.txt;" \
		meson.build || die "Failed changing UnicodeData.txt to system's copy"
	sed -i "s;unicode/emoji-data.txt;${EPREFIX}/usr/share/unicode-data/emoji/emoji-data.txt;" \
		meson.build || die "Failed changing emoji-data.txt to system's copy"
}

src_configure() {
	local emesonargs=(
		$(meson_feature harfbuzz grapheme-shaping)
		$(meson_feature libutf8proc run-shaping)
		$(meson_use examples)
		$(use test && meson_use harfbuzz test-text-shaping)
		-Ddocs=enabled
	)

	meson_src_configure
}

src_install() {
	local DOCS=( CHANGELOG.md README.md )
	meson_src_install

	rm -r "${ED}"/usr/share/doc/${PN} || die

	use examples && newbin "${BUILD_DIR}/example/example" fcft-example
}
