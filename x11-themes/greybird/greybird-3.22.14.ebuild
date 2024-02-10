# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson optfeature

DESCRIPTION="Greybird Desktop Suite"
HOMEPAGE="https://github.com/shimmerproject/Greybird"
SRC_URI="https://github.com/shimmerproject/${PN^}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"

# Theme files, no test case available.
RESTRICT="test"

RDEPEND="x11-libs/gtk+:3
	x11-themes/gtk-engines-murrine"
DEPEND="${RDEPEND}
	dev-lang/sassc
	dev-libs/glib:2"

S="${WORKDIR}/${P^}"

pkg_postinst() {
	optfeature "matching icon theme" x11-themes/elementary-xfce-icon-theme
	optfeature "matching cursor theme" x11-themes/vanilla-dmz-xcursors
}
