# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Reads commands line by line and executes them in parallel"
HOMEPAGE="http://www.maier-komor.de/xjobs.html"
SRC_URI="http://www.maier-komor.de/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND="sys-devel/flex"
RDEPEND=""

src_install() {
	default
	use examples && dodoc -r examples
}
