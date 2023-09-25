# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Xfce Gant Icon Theme"
HOMEPAGE="https://www.xfce-look.org/content/show.php/GANT?content=23297"
SRC_URI="http://overlay.uberpenguin.net/icons-xfce-gant-${PV/_p/-}.tar.bz2"
S="${WORKDIR}/Gant.Xfce"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="binchecks strip"

RDEPEND="x11-themes/hicolor-icon-theme"
DEPEND="${RDEPEND}"

src_install() {
	einstalldocs
	rm icons/iconrc~ README || die

	insinto /usr/share/icons/Gant.Xfce
	doins -r .
}
