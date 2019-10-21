# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
ADA_COMPAT=( gnat_201{6,7} )

inherit ada python-single-r1

DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed042
	-> ${P}-src.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${ADA_DEPS}
	dev-python/pyyaml
	dev-ada/gnatcoll[${ADA_USEDEP},projects,shared]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	~dev-ada/langkit-2017"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${PN}-gps-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	default
	rm -r ada/testsuite/tests/acats_parse || die
}

src_configure() {
	ada/manage.py generate || die
}

src_compile() {
	ada/manage.py --verbosity=debug build || die
}

src_test () {
	ada/manage.py test | grep FAILED && die
}

src_install () {
	ada/manage.py install "${D}"/usr
	python_domodule build/python/libadalang.py
}
