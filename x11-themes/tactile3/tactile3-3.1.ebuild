# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The third evolution of Tactile theme series"
HOMEPAGE="http://gnome-look.org/content/show.php/Tactile3?content=111845"
SRC_URI="http://gnome-look.org/CONTENT/content-files/111845-${PN^}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-themes/hicolor-icon-theme"

S="${WORKDIR}/${PN^}"

src_install() {
	insinto /usr/share/themes/${PN^}
	doins -r .
}
