# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes

ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/libMems/trunk"

inherit autotools-utils subversion

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
IUSE="doc"
KEYWORDS=""

CDEPEND="
	dev-libs/boost
	sci-libs/libgenome
	sci-libs/libmuscle"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"
