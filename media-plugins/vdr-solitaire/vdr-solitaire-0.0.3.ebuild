# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Solitaire game"
HOMEPAGE="https://web.archive.org/web/20150928211126/http://www.djdagobert.com/vdr/solitaire/"
SRC_URI="https://web.archive.org/web/20150928211126/http://www.djdagobert.com/vdr/solitaire/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-1.3.25"
RDEPEND="${DEPEND}"

SOLITAIRE_DATA_DIR="/usr/share/vdr/solitaire"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i cards.c cursor.c \
		-e 's#cPlugin::ConfigDirectory("solitaire")#"'${SOLITAIRE_DATA_DIR}'"#' \
		|| die

	sed -i solitaire.c -e "s:RegisterI18n://RegisterI18n:" || die
}

src_install() {
	vdr-plugin-2_src_install

	insinto "${SOLITAIRE_DATA_DIR}"
	doins "${S}"/solitaire/*.xpm
}
