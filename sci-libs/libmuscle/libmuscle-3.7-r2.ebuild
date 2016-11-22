# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

MY_TAG="mauve-2-3-0-release"
#ESVN_REPO_URI="https://svn.code.sf.net/p/mauve/code/muscle/tags/${MY_TAG}"

#inherit subversion autotools
inherit autotools eutils

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
#SRC_URI=""
SRC_URI="mirror://gentoo/${P}-r1.tar.bz2"

LICENSE="public-domain"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

DEPEND="doc? ( app-doc/doxygen )
	!sci-biology/muscle"
RDEPEND=""

#S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-bufferoverflow.patch
	eautoreconf
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake install DESTDIR="${D}" || die
}
