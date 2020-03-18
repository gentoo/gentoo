# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

BIOPERL_RELEASE=1.6.9

MY_PN=BioPerl-Network
MODULE_AUTHOR=CJFIELDS
MODULE_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl tools for bioinformatics - Analysis of protein-protein interaction networks"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"
SRC_TEST="do"

CDEPEND=">=sci-biology/bioperl-${PV}
	>=dev-perl/Graph-0.86"
DEPEND="dev-perl/Module-Build
	${CDEPEND}"
RDEPEND="${CDEPEND}"

src_install() {
	mydoc="AUTHORS BUGS"
	perl-module_src_install
}
