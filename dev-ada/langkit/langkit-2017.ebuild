# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MYPN=${PN}-gps-src

DESCRIPTION="A Python framework to generate language parsers"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed044
	-> ${MYPN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll[gnat_2017,iconv,shared]
	dev-python/mako
	dev-python/pyyaml
	dev-python/enum34
	dev-python/funcy
	dev-python/docutils
	dev-python/quex"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYPN}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_test() {
	testsuite/testsuite.py | grep FAILED && die "Test failed"
}

src_install() {
	default
	python_domodule langkit
	python_doscript scripts/create-project.py
}
