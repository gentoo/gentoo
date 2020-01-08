# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
ADA_COMPAT=( gnat_201{8,9} )

inherit ada python-single-r1

MYP=${P}-20190510-19916-src
DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8f3331e87a8f1c967d27
	-> ${MYP}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs"

RDEPEND="dev-python/pyyaml
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},iconv,shared=,static-libs=]
	${ADA_DEPS}
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]
	>=dev-ada/langkit-2019"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	ada/manage.py -v debug generate || die
}

src_compile() {
	libtype=relocatable
	if use shared; then
		if use static-libs; then
			libtype=static,relocatable
		fi
	elif use static-libs; then
		libtype=static
	fi
	ada/manage.py \
		-v \
		--library-types $libtype \
		build \
		--build-mode='prod' || die
}

src_test () {
	ada/manage.py test | tee libadalang.testOut;
	grep -q FAILED libadalang.testOut && die
}

src_install () {
	ada/manage.py \
		-v \
		--library-types $libtype \
		install "${D}"/usr || die
	python_domodule build/python/libadalang
	rm -r "${D}"/usr/python || die
}
