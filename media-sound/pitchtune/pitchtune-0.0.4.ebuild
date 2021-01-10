# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Precise Instrument Tweaking for Crispy Harmony - tuner"
HOMEPAGE="https://sourceforge.net/projects/pitchtune/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.4-lm.patch
	"${FILESDIR}"/${PN}-0.0.4-fno-common.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	dodoc REQUIRED

	doicon pixmaps/${PN}.xpm
	make_desktop_entry ${PN} Pitchtune
}
