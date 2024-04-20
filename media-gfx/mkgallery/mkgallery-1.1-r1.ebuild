# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Creates thumbnails and a HTML index file for a directory of jpg files"
HOMEPAGE="https://jaafreitas.github.io/mkgallery/"
SRC_URI="https://github.com/jaafreitas/${PN}/releases/download/v${PV}/${P/-/_}.tgz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"

RDEPEND="
	app-alternatives/bc
	virtual/imagemagick-tools
"

src_install() {
	dobin mkgallery
	einstalldocs
}
