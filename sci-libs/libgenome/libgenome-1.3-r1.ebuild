# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libgenome/libgenome-1.3-r1.ebuild,v 1.1 2009/12/06 00:54:27 weaver Exp $

EAPI="2"

MY_TAG="mauve-2-3-0-release"
#ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/libGenome/tags/${MY_TAG}"

#inherit subversion autotools
inherit autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
#SRC_URI=""
SRC_URI="mirror://gentoo/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die
}
