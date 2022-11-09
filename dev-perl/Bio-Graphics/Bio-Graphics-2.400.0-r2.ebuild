# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CJFIELDS
DIST_VERSION=2.40
inherit perl-module

DESCRIPTION="Generate images from Bio::Seq objects for visualization purposes"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="coldspringharbor"

RDEPEND="
	dev-perl/CGI
	>=dev-perl/GD-2.300.0[jpeg(+)]
	>=dev-perl/Statistics-Descriptive-2.600.0
	<=sci-biology/bioperl-1.6.924
	>=sci-biology/bioperl-1.5.9.1
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"
