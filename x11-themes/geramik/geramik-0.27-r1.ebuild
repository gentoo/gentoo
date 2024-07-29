# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GTK+1 and GTK+2 Geramik Themes"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=3952"
SRC_URI="http://www.kde-look.org/content/files/3952-${P^}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="x11-themes/gtk-engines-qtpixmap"

S="${WORKDIR}/${P^}"
