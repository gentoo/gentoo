# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GD-Graph3d/GD-Graph3d-0.630.0-r1.ebuild,v 1.1 2014/08/21 19:43:00 axs Exp $

EAPI=5

MODULE_AUTHOR=WADG
MODULE_VERSION=0.63
inherit perl-module

DESCRIPTION="Create 3D Graphs with GD and GD::Graph"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/GD-1.18
	>=dev-perl/GDGraph-1.30
	dev-perl/GDTextUtil"
DEPEND="${RDEPEND}"
