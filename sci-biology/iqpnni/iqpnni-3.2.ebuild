# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/iqpnni/iqpnni-3.2.ebuild,v 1.1 2008/10/30 13:43:35 weaver Exp $

DESCRIPTION="Important Quartet Puzzling and NNI Operation"
HOMEPAGE="http://www.cibiv.at/software/iqpnni/"
SRC_URI="http://www.cibiv.at/software/iqpnni/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin src/iqpnni

	dodoc ChangeLog AUTHORS README NEWS TODO
	if use doc ; then
		dohtml manual/iqpnni-manual.html
		insinto /usr/share/doc/${P}
		doins manual/iqpnni-manual.pdf
	fi
}
