# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit perl-module git-2

DESCRIPTION="Perl tools for bioinformatics - Analysis of protein-protein interaction networks"
HOMEPAGE="http://www.bioperl.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/bioperl/${PN}.git"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"
SRC_TEST="do"

CDEPEND=">=sci-biology/bioperl-${PV}
	>=dev-perl/Graph-0.86"
DEPEND="dev-perl/Module-Build
	${CDEPEND}"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/BioPerl-network-${PV}"

src_install() {
	mydoc="AUTHORS BUGS"
	perl-module_src_install
}
