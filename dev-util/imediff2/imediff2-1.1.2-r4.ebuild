# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 python3_6 )
PYTHON_REQ_USE="ncurses"

inherit python-single-r1 versionator

MY_P=${PN}_$(replace_version_separator 3 -)

DESCRIPTION="An interactive, user friendly 2-way merge tool in text mode"
HOMEPAGE="https://elonen.iki.fi/code/imediff/"
SRC_URI="mirror://debian/pool/main/i/${PN}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}/${PV}-python-3.patch" )

src_compile() {
	# Otherwise the docs get regenerated :)
	:
}

src_install() {
	python_doscript imediff2
	dodoc AUTHORS README
	doman imediff2.1
}
