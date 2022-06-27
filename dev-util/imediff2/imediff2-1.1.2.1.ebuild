# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
PYTHON_REQ_USE="ncurses"

inherit python-single-r1

MY_P="${PN}_${PV}"

DESCRIPTION="An interactive, user friendly 2-way merge tool in text mode"
HOMEPAGE="https://elonen.iki.fi/code/imediff/"
SRC_URI="mirror://debian/pool/main/i/${PN}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

#S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${PV}-python-3.patch" )

src_compile() {
	# Otherwise the docs get regenerated :)
	:
}

src_install() {
	python_doscript imediff2
	dobin git-ime
	dodoc AUTHORS README.md
	doman imediff2.1 git-ime.1
}
