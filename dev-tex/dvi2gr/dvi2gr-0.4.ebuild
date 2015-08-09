# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="DVI to Grace translator"
HOMEPAGE="http://plasma-gate.weizmann.ac.il/Grace/"
SRC_URI="ftp://plasma-gate.weizmann.ac.il/pub/grace/src/devel/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="media-libs/t1lib"
RDEPEND="${DEPEND}"

src_prepare() {
	# respect flags
	sed -i \
		-e '/^LDFLAGS/d' -e '/^CFLAGS/d' -e '/^CC/d' \
		Makefile || die
	sed -i -e 's/DVI2GR=\.\/dvi2gr/DVI2GR=$(which dvi2gr)/g' runtest.sh || die
}

src_install() {
	dobin ${PN} || die
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins *.ti  runtest.sh || die
	fi

	insinto /usr/share/${PN}
	doins -r fonts || die
}

pkg_postinst() {
	einfo "Don't forget install the TeX-Fonts in Grace"
	einfo "  /usr/share/${PN}/fonts/FontDataBase"
}
