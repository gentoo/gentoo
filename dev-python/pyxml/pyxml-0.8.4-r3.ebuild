# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxml/pyxml-0.8.4-r3.ebuild,v 1.14 2015/07/20 08:43:24 monsieurp Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_P=${P/pyxml/PyXML}

DESCRIPTION="A collection of libraries to process XML with Python"
HOMEPAGE="http://pyxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD CNRI MIT PSF-2 public-domain"
# Other licenses:
# BeOpen Python Open Source License Agreement Version 1
# Zope Public License (ZPL) Version 1.0
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples"

DEPEND=">=dev-libs/expat-1.95.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-python-2.6.patch"
	)

	distutils-r1_python_prepare_all
}

python_compile() {
	# use the already-installed shared copy of libexpat
	distutils-r1_python_compile --with-libexpat="${EPREFIX}/usr"
}

python_test() {
	# Delete internal copy of old version of unittest module.
	local BROKENTESTS=(
		test_filter
		test_howto
		test_minidom
		test_xmlbuilder
		unittest
		test_expatreader
	)

	for test_file in ${BROKENTESTS[@]}; do
		test_file="test/${test_file}.py"
		einfo "Removing dubious test \"${test_file}\""
		rm ${test_file}
		eend $?
	done

	cd test || die
	"${PYTHON}" regrtest.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( ANNOUNCE CREDITS doc/*.txt )

	distutils-r1_python_install_all

	doman doc/man/*
	if use doc; then
		dohtml -A api,web -r doc/*
		dodoc doc/*.tex
	fi
	use examples && dodoc -r demo
}
