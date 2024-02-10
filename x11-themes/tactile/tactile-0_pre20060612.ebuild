# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nice, calm and dark low contrast GTK+ theme"
HOMEPAGE="http://gnome-look.org/content/show.php/Tactile?content=40771"
SRC_URI="http://gnome-look.org/CONTENT/content-files/40771-${PN^}.tar.gz"

LICENSE="CC-BY-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN^}"

src_install() {
	insinto /usr/share/themes/${PN^}
	doins -r .
}
