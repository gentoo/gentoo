# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-solitaire/vdr-solitaire-0.0.3.ebuild,v 1.2 2014/01/14 19:27:21 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Solitaire game"
HOMEPAGE="http://www.djdagobert.com/vdr/solitaire/index.html"
SRC_URI="http://www.djdagobert.com/vdr/solitaire/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.25"

SOLITAIRE_DATA_DIR="/usr/share/vdr/solitaire"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i cards.c cursor.c \
		-e 's#cPlugin::ConfigDirectory("solitaire")#"'${SOLITAIRE_DATA_DIR}'"#'

	sed -i solitaire.c -e "s:RegisterI18n://RegisterI18n:"
}

src_install() {
	vdr-plugin-2_src_install

	insinto "${SOLITAIRE_DATA_DIR}"
	doins "${S}"/solitaire/*.xpm
}
