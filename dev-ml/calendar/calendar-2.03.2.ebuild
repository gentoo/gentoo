# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/calendar/calendar-2.03.2.ebuild,v 1.2 2013/08/16 23:09:29 aballier Exp $

EAPI=5

inherit findlib eutils

DESCRIPTION="An Ocaml library to handle dates and time"
HOMEPAGE="http://forge.ocamlcore.org/projects/calendar/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/915/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_compile() {
	emake
	use doc && emake doc
}

src_test() {
	emake tests
}

src_install() {
	findlib_src_install
	dodoc README CHANGES
	use doc && dohtml -r doc
}
