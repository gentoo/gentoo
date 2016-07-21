# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# disable automatic phase exports and deps
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils distutils-r1 prefix eutils

DESCRIPTION="CMU Speech Recognition engine"
HOMEPAGE="http://cmusphinx.sourceforge.net/"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc python static-libs"

RDEPEND=">=app-accessibility/sphinxbase-0.7[static-libs?,python?,${PYTHON_USEDEP}]
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Due to generated Python setup.py.
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	epatch "${FILESDIR}/${P}_heap_fix.patch" \
		"${FILESDIR}/${P}-libutil.patch"
	eprefixify 'python/setup.py'
}

src_compile() {
	autotools-utils_src_compile

	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README )
	autotools-utils_src_install

	if use doc; then
		cd doc || die
		dohtml -r -x CVS s3* s3 *.html
	fi

	if use python; then
		unset DOCS

		cd "${S}"/python || die
		distutils-r1_src_install
	fi
}
