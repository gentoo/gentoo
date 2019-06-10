# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MYP=${P}-20190510-19916-src
DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8f3331e87a8f1c967d27
	-> ${MYP}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 gnat_2018 +gnat_2019 +shared static-libs"

RDEPEND="dev-python/pyyaml
	dev-ada/gnatcoll-bindings[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]
	dev-ada/gnatcoll-bindings[iconv,shared=,static-libs=]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-ada/langkit-2018"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	ada/manage.py -v debug generate || die
}

src_compile() {
	ada/manage.py -v debug build --build-mode='prod' || die
}

src_test () {
	ada/manage.py test | tee libadalang.testOut;
	grep -q FAILED libadalang.testOut && die
}

src_install () {
	ada/manage.py install "${D}"/usr || die
	python_domodule build/python/libadalang
	rm -r "${D}"/usr/python || die
}
