# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit python-r1

DESCRIPTION="Enhanced df with colors"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/"
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/${PN}_${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e "s:/etc/pydfrc:${EPREFIX}/etc/pydfrc:" pydf || die
}

src_install() {
	python_foreach_impl python_doscript pydf
	insinto /etc
	doins pydfrc
	doman pydf.1
	dodoc README
}
