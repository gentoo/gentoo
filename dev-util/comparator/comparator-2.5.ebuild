# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/comparator/comparator-2.5.ebuild,v 1.9 2014/10/13 14:22:15 blueness Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils toolchain-funcs

DESCRIPTION="ESR's utility for making fast comparisons among large source trees"
HOMEPAGE="http://www.catb.org/~esr/comparator/"
SRC_URI="http://www.catb.org/~esr/comparator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="sparc"
IUSE=""

RDEPEND=""
DEPEND="=app-text/docbook-xml-dtd-4.1.2*
	app-text/xmlto"

PYTHON_MODNAME="comparator.py"

src_prepare() {
	sed \
		-e '/install -m 755 -o 0 -g 0 filterator/d' \
		-e '/python setup.py install/d' \
		-i Makefile || die "sed failed"
}

src_compile() {
	distutils_src_compile
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
	emake comparator.html scf-standard.html || die "emake html failed"
}

src_install() {
	distutils_src_install
	emake ROOT="${D}" install || die "emake install failed"

	install_filterator() {
		newbin filterator filterator-${PYTHON_ABI} || return 1
		python_convert_shebangs ${PYTHON_ABI} "${ED}usr/bin/filterator-${PYTHON_ABI}"
	}
	python_execute_function -q install_filterator
	python_generate_wrapper_scripts "${ED}usr/bin/filterator"

	dohtml *.html || die "dohtml failed"
}
