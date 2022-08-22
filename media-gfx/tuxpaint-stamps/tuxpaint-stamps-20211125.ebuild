# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-${PV:0:4}.${PV:4:2}.${PV:6:2}

DESCRIPTION="Set of 'Rubber Stamp' images which can be used within Tux Paint"
HOMEPAGE="http://www.tuxpaint.org/"
SRC_URI="mirror://sourceforge/tuxpaint/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="media-gfx/tuxpaint"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-make-382.patch
)

src_install() {
	emake PREFIX="${D}/usr" install-all

	rm -f docs/COPYING.txt || die
	dodoc docs/*.txt
}
