# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/newick-utils/newick-utils-1.5.0.ebuild,v 1.2 2011/07/13 14:45:45 xarthisius Exp $

EAPI="2"

DESCRIPTION="Tools for processing phylogenetic trees (re-root, subtrees, trimming, pruning, condensing, drawing)"
HOMEPAGE="http://cegg.unige.ch/newick_utils"
SRC_URI="http://cegg.unige.ch/pub/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="!dev-games/libnw"

src_install() {
	einstall || die
}

src_test() {
	emake -C tests check-TESTS || die
}
