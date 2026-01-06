# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools dotnet

DESCRIPTION="C-based implementation of the GDI+ API"
HOMEPAGE="https://www.mono-project.com"
#SRC_URI="https://dl.winehq.org/mono/sources/libgdiplus/${P}.tar.gz"
# https://gitlab.winehq.org/mono/libgdiplus/-/issues/2
SRC_URI="https://dev.gentoo.org/~sam/distfiles/dev-dotnet/libgdiplus/libgdiplus-6.2.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="cairo"

RDEPEND="dev-libs/glib:2
	media-libs/freetype
	media-libs/fontconfig
	>=media-libs/giflib-5.1.2:=
	media-libs/libexif
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	!cairo? ( x11-libs/pango )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# Don't default to pango when `--with-pango` is not given.
	# Link against correct pango libraries. Bug #700280
	sed -e 's/text_v=default/text_v=cairo/' \
		-e 's/pangocairo/pangocairo pangoft2/' \
		-i configure.ac || die
	eautoreconf

	# User configuration for fontconfig affects whether this test passes or not
	sed -e '/main(int argc, char\*\*argv)/,/^}$/ { /\(test_createFontFamilyFromName\|test_cloneFontFamily\|test_getFamilyName\)/d }' \
		-i tests/testfont.c || die
}

src_configure() {
	econf \
		--disable-static \
		$(usex cairo "" "--with-pango")
}

src_install() {
	default

	dotnet_multilib_comply
	local commondoc=( AUTHORS ChangeLog README TODO )
	for docfile in "${commondoc[@]}"; do
		[[ -e "${docfile}" ]] && dodoc "${docfile}"
	done
	[[ "${DOCS[@]}" ]] && dodoc "${DOCS[@]}"
	find "${ED}" -name '*.la' -delete || die
}
