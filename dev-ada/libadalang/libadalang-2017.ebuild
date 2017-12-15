# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed042
	-> ${P}-src.tar.gz
	http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed044
	-> langkit-gps-src-${PV}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnat_2016 gnat_2017"

RDEPEND="dev-python/pyyaml
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gnatcoll[projects,shared,gnat_2016=,gnat_2017=]
	dev-python/docutils
	dev-python/mako
	dev-python/enum34
	dev-python/quex
	dev-python/funcy"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	rm -r ${PN}-gps-src/ada/testsuite/tests/{acats_parse,stylechecks} || die
}

src_compile() {
	cd ${PN}-gps-src
	mkdir bin
	ln -sf /usr/bin/gnatbind-4.9.4 bin/gnatbind
	PATH=$PATH:${PWD}/bin \
		PYTHONPATH=${PYTHONPATH}:"${WORKDIR}"/langkit-gps-src \
		GCC=${CHOST}-gcc-4.9.4 ada/manage.py make || die
}

src_test () {
	local myDir="${WORKDIR}"/${PN}-gps-src
	cd ${PN}-gps-src/ada/testsuite
	ln -sf "${myDir}"/build/include/libadalang.h c_support/libadalang.h
	#./testsuite.py --show-error-output |& grep FAILED && die "Test failed"
	GPR_PROJECT_PATH="${myDir}"/build/lib/gnat \
		LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${myDir}"/build/lib/libadalang.relocatable \
		PYTHONPATH="${myDir}"/build/python \
		PATH=${PATH}:"${myDir}"/build/bin ./testsuite.py --show-error-output
	rm c_support/libadalang.h
	cd -
}

src_install () {
	cd ${PN}-gps-src
	PYTHONPATH=${PYTHONPATH}:"${WORKDIR}"/langkit-gps-src \
		ada/manage.py install "${D}"usr
	python_domodule build/python/libadalang.py
}
