# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A text filtering pipe that marks each line with a timestamp"
HOMEPAGE="http://math.smsu.edu/~erik/software.php?id=95"
SRC_URI="http://math.smsu.edu/~erik/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="!sys-apps/moreutils"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog )

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
