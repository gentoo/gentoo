# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Convenient factorization helper script using msieve and ggnfs"
HOMEPAGE="http://gladman.plushost.co.uk/oldsite/computing/factoring.php"
SRC_URI="http://gladman.plushost.co.uk/oldsite/computing/${PN}.${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sci-mathematics/msieve
	sci-mathematics/ggnfs"
DEPEND=""

S="${WORKDIR}"
PATCHES=( "${FILESDIR}/${P}.patch" )

src_install() {
	python_fix_shebang ${PN}.py
	dobin ${PN}.py
}
