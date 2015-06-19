# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bio-Graphics/Bio-Graphics-2.370.0-r1.ebuild,v 1.2 2015/06/13 19:34:39 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=2.37
inherit perl-module

DESCRIPTION="Generate images from Bio::Seq objects for visualization purposes"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/GD
	dev-perl/Statistics-Descriptive"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=no
