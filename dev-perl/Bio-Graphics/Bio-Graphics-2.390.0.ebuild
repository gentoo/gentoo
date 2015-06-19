# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bio-Graphics/Bio-Graphics-2.390.0.ebuild,v 1.2 2015/06/13 19:34:39 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=2.39
inherit perl-module

DESCRIPTION="Generate images from Bio::Seq objects for visualization purposes"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/GD-2.300.0
	>=dev-perl/Statistics-Descriptive-2.600.0
	>=sci-biology/bioperl-1.5.9.1

"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"

SRC_TEST=do
