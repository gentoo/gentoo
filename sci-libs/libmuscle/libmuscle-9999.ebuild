# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

ESVN_REPO_URI="https://svn.code.sf.net/p/mauve/code/muscle/trunk"

inherit subversion autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
IUSE="doc"
KEYWORDS=""

DEPEND="doc? ( app-doc/doxygen )
	!sci-biology/muscle"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	eautoreconf
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake install DESTDIR="${D}" || die
}
