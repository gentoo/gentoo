# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ncurses"

inherit python-single-r1

MY_PN="${PN}2"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="2-way/3-way merge tool (CLI, Ncurses)"
HOMEPAGE="https://github.com/osamuaoki/imediff"
SRC_URI="mirror://debian/pool/main/i/${MY_PN}/${MY_P}.orig.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

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
