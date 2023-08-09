# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils toolchain-funcs

DESCRIPTION="Traditional game of Brunei"
HOMEPAGE="https://pasang-emas.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	extras? (
		mirror://sourceforge/${PN}/pasang-emas-themes-1.0.tar.bz2
		mirror://sourceforge/${PN}/pet-marble.tar.bz2
		mirror://sourceforge/${PN}/pet-fragrance.tar.bz2
	)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extras nls"
RESTRICT="test" # only used to validate .xml help files and fetches .dtd for it

RDEPEND="
	app-text/gnome-doc-utils
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rarian
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default

	sed -i '/Encoding/d;/Icon/s:\.png::' data/pasang-emas.desktop.in || die

	gnome2_omf_fix
}

src_configure() {
	local econfargs=(
		$(use_enable nls)
		--with-help-dir="${EPREFIX}"/usr/share/gnome/help
		--with-omf-dir="${EPREFIX}"/usr/share/omf
	)
	econf "${econfargs[@]}"
}

src_compile(){
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	if use extras; then
		insinto /usr/share/${PN}/themes
		doins -r "${WORKDIR}"/{fragrance,marble,pasang-emas-themes-1.0/{conteng,kaca}}
	fi
}

pkg_preinst() {
	gnome2_scrollkeeper_savelist
}

pkg_postinst() {
	gnome2_scrollkeeper_update
}

pkg_postrm() {
	gnome2_scrollkeeper_update
}
