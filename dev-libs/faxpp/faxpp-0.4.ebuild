# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/faxpp/faxpp-0.4.ebuild,v 1.3 2014/08/10 20:33:40 slyfox Exp $

DESCRIPTION="Small, fast and conformant XML pull parser written in C with an API that can return UTF-8 or UTF-16 strings"
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
