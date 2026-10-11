# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_PN="${PN}$(ver_cut 1)"
inherit font

DESCRIPTION="The iconic font"
HOMEPAGE="https://fontawesome.com"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FortAwesome/Font-Awesome.git"
else
	SRC_URI="https://github.com/FortAwesome/Font-Awesome/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/Font-Awesome-${PV}"
fi

LICENSE="CC-BY-4.0 OFL-1.1"
SLOT="$(ver_cut 1)"
IUSE="ttf"

RDEPEND="ttf? ( !media-fonts/fontawesome:5[ttf] )"

src_install() {
	FONT_S="${S}/otfs" FONT_SUFFIX="otf" font_src_install
	if use ttf; then
		FONT_S="${S}/webfonts" FONT_SUFFIX="ttf" font_src_install
	fi
}
