# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/utidylib/utidylib-0.2-r1.ebuild,v 1.9 2015/05/08 07:33:35 jlec Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="trial tidy"

inherit distutils eutils

MY_P="uTidylib-${PV}"

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="http://sourceforge.net/projects/utidylib/"
SRC_URI="mirror://berlios/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="doc"

RDEPEND="app-text/htmltidy"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-python/epydoc )"
RESTRICT_PYTHON_ABIS="2.4 3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="tidy"

src_prepare(){
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-no-docs-in-site-packages.patch"
	epatch "${FILESDIR}/${P}-fix_tests.patch"
}

src_compile() {
	distutils_src_compile
	if use doc; then
		"$(PYTHON -f)" gendoc.py || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install
	use doc && dohtml -r apidoc
}
