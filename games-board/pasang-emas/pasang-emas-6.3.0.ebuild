# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Traditional game of Brunei"
HOMEPAGE="https://pasang-emas.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}.tar.xz
	extras? (
		https://downloads.sourceforge.net/${PN}/pasang-emas-themes-1.0.tar.bz2
		https://downloads.sourceforge.net/${PN}/pet-marble.tar.bz2
		https://downloads.sourceforge.net/${PN}/pet-fragrance.tar.bz2
	)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extras"
RESTRICT="test" # only used to validate .xml help files and fetches .dtd for it

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/itstool"

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
