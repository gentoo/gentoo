# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit python-r1

DESCRIPTION="Enhanced df with colors"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/"
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/${PN}_${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"
BDEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "s#/etc/pydfrc#${EPREFIX}/etc/pydfrc#" "${PN}" || die
}

src_install() {
	python_foreach_impl python_doscript "${PN}"
	insinto /etc
	doins "${PN}rc"
	doman "${PN}.1"
	einstalldocs
}
