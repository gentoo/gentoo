# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils qmake-utils git-r3

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://github.com/lupoDharkael/flameshot"
EGIT_REPO_URI="https://github.com/lupoDharkael/flameshot.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="dev-qt/qtcore:5
		dev-qt/qtsvg:5
		dev-qt/qtnetwork:5
		dev-qt/linguist-tools:5
"

src_configure() {
	if tc-is-gcc && [[ $(gcc-fullversion) -lt 4.9.2 ]]; then
		die "Flameshot requires GCC >= 4.9.2, but you have GCC $(gcc-fullversion)"
	fi
	eqmake5 CONFIG+=packaging flameshot.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
