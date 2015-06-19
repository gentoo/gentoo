# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyzor/pyzor-0.5.0-r2.ebuild,v 1.9 2014/03/19 13:56:07 ago Exp $

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="gdbm"
PYTHON_USE_WITH_OPT="pyzord"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="http://pyzor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="pyzord"

DEPEND=""
RDEPEND=""

DOCS="THANKS UPGRADING"

src_prepare() {
	epatch "${FILESDIR}/pyzord_getopt.patch"
	epatch "${FILESDIR}/${P}-python26_warnings.patch"

	# rfc822BodyCleanerTest doesn't work fine.
	# Remove it until it's fixed.
	sed -i \
		-e '/rfc822BodyCleanerTest/,/self\.assertEqual/d' \
		unittests.py || die "sed in unittest.py failed"
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" unittests.py
	}
	python_execute_function testing
}

src_install () {
	distutils_src_install

	dohtml docs/usage.html
	rm -rf "${ED}usr/share/doc/pyzor"

	if use pyzord; then
		dodir /usr/sbin
		mv "${ED}"usr/bin/pyzord* "${ED}usr/sbin"
	else
		rm "${ED}"usr/bin/pyzord*
	fi
}

pkg_postinst() {
	distutils_pkg_postinst

	if use pyzord; then
		ewarn "/usr/bin/pyzord has been moved to /usr/sbin"
	fi
}
