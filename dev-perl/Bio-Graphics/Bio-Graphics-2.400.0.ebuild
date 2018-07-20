# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CJFIELDS
DIST_VERSION=2.40
inherit perl-module

DESCRIPTION="Generate images from Bio::Seq objects for visualization purposes"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/GD-2.300.0
	dev-perl/CGI
	|| ( >=dev-perl/Bio-Coordinate-1.7.1 <=sci-biology/bioperl-1.6.924 )
	>=dev-perl/Statistics-Descriptive-2.600.0
	>=sci-biology/bioperl-1.5.9.1
	dev-perl/CGI
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"
