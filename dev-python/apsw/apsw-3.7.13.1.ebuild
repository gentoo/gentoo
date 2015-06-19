# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/apsw/apsw-3.7.13.1.ebuild,v 1.5 2013/08/28 16:01:09 floppym Exp $

EAPI="4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 2.7-pypy-*"

inherit distutils eutils versionator

MY_PV="$(replace_version_separator 3 -r)"

DESCRIPTION="APSW - Another Python SQLite Wrapper"
HOMEPAGE="http://code.google.com/p/apsw/"
SRC_URI="http://apsw.googlecode.com/files/${PN}-${MY_PV}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="doc"

RDEPEND=">=dev-db/sqlite-$(get_version_component_range 1-3)"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}-${MY_PV}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-3.6.20.1-fix_tests.patch"
}

src_compile() {
	distutils_src_compile --enable=load_extension
}

src_test() {
	echo "$(PYTHON -f)" setup.py build_test_extension
	"$(PYTHON -f)" setup.py build_test_extension || die "Building of test loadable extension failed"

	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" tests.py -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use doc ; then
		dohtml -r doc/*
	fi
}
