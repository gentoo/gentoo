# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# https://github.com/mate-desktop/mate-icon-theme-faenza/issues/13
MATE_FORCE_AUTORECONF=true
inherit mate

DESCRIPTION="Faenza icon theme that was adapted for MATE desktop"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="minimal"

RESTRICT="binchecks strip"

RDEPEND="x11-themes/hicolor-icon-theme:0
	!minimal? ( >=x11-themes/mate-icon-theme-${MATE_BRANCH} )"

src_prepare() {
	# Remove broken libreoffice icons (dangling symlinks).
	rm matefaenza/apps/16/*libreoffice* || die

	mate_src_prepare
}
