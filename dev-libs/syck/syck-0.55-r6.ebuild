# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/syck/syck-0.55-r6.ebuild,v 1.1 2015/02/13 06:08:23 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 flag-o-matic

DESCRIPTION="Syck is an extension for reading and writing YAML swiftly in popular scripting languages"
HOMEPAGE="http://whytheluckystiff.net/syck/"
SRC_URI="http://rubyforge.org/frs/download.php/4492/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="php python"

DEPEND="python? ( !dev-python/pysyck )"
RDEPEND="${DEPEND}"
PDEPEND="php? ( dev-php/pecl-syck
		    !=dev-libs/syck-0.55-r1 )"
pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/syck-0.55-64bit.patch"
}

src_configure() {
	append-flags -fPIC
	econf
}

src_compile() {
	emake
	if use python; then
		pushd ext/python > /dev/null
		distutils-r1_src_compile
		popd > /dev/null
	fi
}

src_install() {
	emake DESTDIR=${D} install
	if use python; then
		pushd ext/python > /dev/null
		distutils-r1_src_install
		popd > /dev/null
	fi
	distutils-r1_python_install_all
}
