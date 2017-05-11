# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit python-r1

DESCRIPTION="Enhanced df with colors"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/"
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/${PN}_${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	default
	sed -i -e "s:/etc/pydfrc:${EPREFIX}/etc/pydfrc:" "${PN}" || die
}

src_install() {
	python_foreach_impl python_doscript "${PN}"
	insinto /etc
	doins "${PN}rc"
	doman "${PN}.1"
	einstalldocs
}
