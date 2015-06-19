# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_python/mod_python-3.5.0.ebuild,v 1.8 2015/06/02 05:18:18 jmorgan Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit apache-module eutils python-single-r1

DESCRIPTION="An Apache2 module providing an embedded Python interpreter"
HOMEPAGE="http://modpython.org/"
SRC_URI="http://dist.modpython.org/dist/${P}.tgz"

LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE="doc test"
SLOT="0"

APACHE2_MOD_CONF="16_${PN}"
APACHE2_MOD_DEFINE="PYTHON"
need_apache2

RDEPEND="${RDEPEND}"
DEPEND="${DEPEND}
	test? (
		app-admin/apache-tools
		net-misc/curl
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch

	export CFLAGS="$(apxs2 -q CFLAGS)"
	export LDFLAGS="$(apxs2 -q LDFLAGS)"
}

src_compile() {
	default
}

src_test() {
	cd test || die
	PYTHONPATH="$(ls -d ${S}/dist/build/lib.*)" ${PYTHON} test.py || die
}

src_install() {
	default

	use doc && dohtml -r doc-html/*

	apache-module_src_install
}
