# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Gargantuan Icon Theme"
HOMEPAGE="https://www.gnome-look.org/content/show.php?content=24364"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="x11-themes/hicolor-icon-theme"

S="${WORKDIR}"/gargantuan

src_install() {
	dodoc README
	rm -f index.theme~ index.theme.old icons/iconrc~ README || die
	insinto /usr/share/icons/gargantuan
	doins -r *
}
