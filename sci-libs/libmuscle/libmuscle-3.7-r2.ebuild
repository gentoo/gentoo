# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libmuscle/libmuscle-3.7-r2.ebuild,v 1.1 2010/06/28 20:37:43 jlec Exp $

EAPI="2"

MY_TAG="mauve-2-3-0-release"
#ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/muscle/tags/${MY_TAG}"

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
