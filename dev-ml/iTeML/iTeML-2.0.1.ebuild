# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/iTeML/iTeML-2.0.1.ebuild,v 1.2 2014/10/30 16:44:55 aballier Exp $

EAPI=5

inherit oasis

DESCRIPTION="Inline (Unit) Tests for OCaml"
HOMEPAGE="https://github.com/vincent-hugot/iTeML"
SRC_URI="https://github.com/vincent-hugot/iTeML/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ml/ounit:="
DEPEND="${RDEPEND}
	dev-ml/oasis"

DOCS=( "${WORKDIR}/${P}/README.md" )

S="${WORKDIR}/${P}/qtest"

src_prepare() {
	oasis setup || die
}
