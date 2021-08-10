# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg-utils

DESCRIPTION="Fast and usable calculator for power users"
HOMEPAGE="https://speedcrunch.org/"
SRC_URI="https://bitbucket.org/heldercorreia/${PN}/get/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/heldercorreia-speedcrunch-ea93b21f9498/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-appdata.patch" )

src_install() {
	use doc && local HTML_DOCS=( ../doc/build_html_embedded/. )
	cmake_src_install
	doicon -s scalable ../gfx/speedcrunch.svg
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
