# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Small, fast and conformant XML pull parser written in C"
HOMEPAGE="http://faxpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog TODO

	use doc && dohtml docs/api/*
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
