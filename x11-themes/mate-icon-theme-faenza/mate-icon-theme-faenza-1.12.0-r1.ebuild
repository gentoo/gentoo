# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Faenza icon theme, that was adapted for MATE desktop"
LICENSE="GPL-3"
SLOT="0"

IUSE="minimal"

RDEPEND="x11-themes/hicolor-icon-theme:0
	!minimal? ( >=x11-themes/mate-icon-theme-${MATE_BRANCH} )"

RESTRICT="binchecks strip"

# https://github.com/mate-desktop/mate-icon-theme-faenza/issues/13
MATE_FORCE_AUTORECONF=true

src_prepare() {
	# Remove broken libreoffice icons (dangling symlinks).
	rm matefaenza/apps/16/*libreoffice* || die

	mate_src_prepare
}
