# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avra/avra-1.3.0.ebuild,v 1.4 2011/08/06 12:27:52 maekke Exp $

EAPI=4

inherit autotools

DESCRIPTION="Atmel AVR Assembler"
HOMEPAGE="http://avra.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples"

S="${WORKDIR}/${P}/src/"

src_prepare() {
	eautoreconf
}

src_install() {
	local datadir="${WORKDIR}/${P}"

	default

	dodoc ${datadir}/{AUTHORS,INSTALL,README,TODO}

	# install headers
	insinto /usr/include/avr
	doins "${datadir}/includes/"*

	use doc && dohtml -r "${datadir}/doc/"*

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins "${datadir}/examples/"*
	fi
}
