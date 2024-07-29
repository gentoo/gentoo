# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BIOPERL_RELEASE=1.6.9

DIST_AUTHOR=CJFIELDS
DIST_NAME=BioPerl-Network
DIST_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl tools for bioinformatics - Analysis of protein-protein interaction networks"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test" # bug 298326

RDEPEND="
	>=sci-biology/bioperl-${PV}
	>=dev-perl/Graph-0.86"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"

mydoc="AUTHORS BUGS"
