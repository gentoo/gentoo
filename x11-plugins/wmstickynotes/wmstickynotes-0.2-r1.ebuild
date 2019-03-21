# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A dockapp for keeping small notes around on the desktop"
HOMEPAGE="https://sourceforge.net/projects/wmstickynotes/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gold.patch )
