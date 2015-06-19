# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mauvealigner/mauvealigner-9999.ebuild,v 1.1 2009/04/17 18:03:19 weaver Exp $

EAPI="2"

ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/mauveAligner/trunk"

inherit subversion autotools

DESCRIPTION="Multiple genome alignment with large-scale evolutionary events (aligner component)"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS=""

CDEPEND="sci-libs/libgenome
	sci-libs/libmuscle
	sci-libs/libmems"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die
}
