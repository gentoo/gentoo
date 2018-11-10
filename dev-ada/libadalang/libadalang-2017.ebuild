# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed042
	-> ${P}-src.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 +gnat_2017"

RDEPEND="dev-python/pyyaml
	dev-ada/gnatcoll[projects,shared,gnat_2016=,gnat_2017=]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/langkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${PN}-gps-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	rm -r ada/testsuite/tests/acats_parse || die
}

src_configure() {
	ada/manage.py generate || die
}

src_compile() {
	ada/manage.py build || die
}

src_test () {
	ada/manage.py test | grep FAILED && die
}

src_install () {
	ada/manage.py install "${D}"usr
	python_domodule build/python/libadalang.py
}
