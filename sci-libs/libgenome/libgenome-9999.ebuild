# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libgenome/libgenome-9999.ebuild,v 1.1 2009/04/03 16:37:15 weaver Exp $

EAPI="2"

ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/libGenome/trunk"

inherit subversion autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS=""

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die
}
