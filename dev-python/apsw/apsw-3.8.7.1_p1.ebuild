# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PV=${PV/_p/-r}
MY_P=${PN}-${MY_PV}

DESCRIPTION="APSW - Another Python SQLite Wrapper"
HOMEPAGE="https://code.google.com/p/apsw/"
HOMEPAGE="https://github.com/rogerbinns/apsw/"
SRC_URI="https://github.com/rogerbinns/apsw/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86"
IUSE="doc"

RDEPEND=">=dev-db/sqlite-${PV%_p*}"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-3.6.20.1-fix_tests.patch )

python_compile() {
	if ! python_is_python3; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"
		export CFLAGS
	fi
	distutils-r1_python_compile --enable=load_extension
}

python_test() {
	"${PYTHON}" setup.py build_test_extension || die "Building of test loadable extension failed"
	"${PYTHON}" tests.py -v || die
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc ; then
		dohtml -r doc/*
	fi
}
