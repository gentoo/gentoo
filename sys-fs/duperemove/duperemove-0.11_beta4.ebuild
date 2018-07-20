# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Btrfs deduplication utility"
HOMEPAGE="https://github.com/markfasheh/duperemove"
SRC_URI="https://github.com/markfasheh/duperemove/archive/v${PV/_/.}.tar.gz -> ${P/_/.}.tar.gz"

# includes code from libbloom, xxhash (BSD-2)
# includes code from polarssl (GPL-2+)
LICENSE="GPL-2 GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-db/sqlite:3=
	dev-libs/glib:2="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/_/.}

PATCHES=( "${FILESDIR}/${P}-sysmacros.patch" )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
