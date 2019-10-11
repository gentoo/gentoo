# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
FONT_PN=jmk

inherit font

MY_P=jmk-x11-fonts-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="This package contains character-cell fonts for use with X"
SRC_URI="http://www.pobox.com/~jmknoble/fonts/${MY_P}.tar.gz"
HOMEPAGE="http://www.jmknoble.net/fonts/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="x11-misc/imake
	x11-apps/mkfontdir
	x11-apps/bdftopcf"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	eapply "${FILESDIR}"/gzip.patch
}

src_compile() {
	xmkmf || die
	emake || die
}

src_install() {
	make install INSTALL_DIR="${D}${FONTDIR}" || die
	dodoc README NEWS
}
