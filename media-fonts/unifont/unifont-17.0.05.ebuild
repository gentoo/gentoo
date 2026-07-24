# Copyright 2003-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font optfeature toolchain-funcs

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="https://unifoundry.com/"
SRC_URI="mirror://gnu/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2+ || ( GPL-2+-with-font-exception OFL-1.1 ) public-domain utils? ( FDL-1.3+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="ttf utils"
REQUIRED_USE="ttf? ( utils )"

BDEPEND="
	media-libs/fontconfig
	utils? (
		app-text/bdf2psf
		x11-apps/bdftopcf
		ttf? ( media-gfx/fontforge )
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-17.0.03-Makefile.patch
	"${FILESDIR}"/${PN}-17.0.05-Makefile.patch
	"${FILESDIR}"/${PN}-17.0.05-fix_parallel.patch
)

src_compile() {
	if use utils; then
		tc-export CC
		emake bindir libdir

		local font_targets=(
			opentype
			pcf
			psf
			$(usev ttf truetype)
			# compile unifont_all.hex
			$(usev utils coverage)
		)
		emake -C font "${font_targets[@]}"
	fi
}

src_install() {
	local installargs=(
		DESTDIR="${ED}"
		OTFDEST="${ED}${FONTDIR}"
		PCFDEST="${ED}${FONTDIR}"
	)
	emake "${installargs[@]}" -C font install

	if use ttf; then
		pushd "${S}"/font/compiled >/dev/null || die
		insinto /usr/share/fonts/unifont
		local files
		for files in *.ttf; do
			newins "${files}" "${files/-${PV}/}"
		done
		popd >/dev/null || die
	fi

	if use utils; then
		emake DESTDIR="${ED}" install

		local HTML_DOCS=( doxygen/html/. )
		find "${HTML_DOCS[@]}" \( -iname '*.md5' -o -iname '*.map' \) -delete || die

		doman man/*.{1,5}
	fi

	einstalldocs

	font_xfont_config
	font_fontconfig
}

pkg_postinst() {
	font_pkg_postinst

	use utils && optfeature "unifont-viewer" dev-perl/Wx
	use utils && optfeature "unipng2hex"  dev-perl/GD virtual/perl-Getopt-Long
}
