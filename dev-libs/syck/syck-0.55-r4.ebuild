# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/syck/syck-0.55-r4.ebuild,v 1.18 2014/08/10 20:39:40 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils eutils flag-o-matic

DESCRIPTION="Syck is an extension for reading and writing YAML swiftly in popular scripting languages"
HOMEPAGE="http://whytheluckystiff.net/syck/"
SRC_URI="http://rubyforge.org/frs/download.php/4492/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="php python"

DEPEND="python? ( !dev-python/pysyck )"
RDEPEND="${DEPEND}"
PDEPEND="php? ( dev-php/pecl-syck
		    !=dev-libs/syck-0.55-r1 )"

DISTUTILS_SETUP_FILES=("ext/python|setup.py")
PYTHON_MODNAME="yaml2xml.py ydump.py ypath.py"

pkg_setup() {
	use python && python_pkg_setup
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
	use python && distutils_src_compile
}

src_install() {
	einstall
	use python && distutils_src_install
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
