# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PerlIO-Layers/PerlIO-Layers-0.10.0.ebuild,v 1.5 2014/07/30 17:00:57 zlogene Exp $

EAPI=5

MODULE_AUTHOR="LEONT"
MODULE_VERSION=0.010

inherit perl-module

DESCRIPTION="Querying your filehandle's capabilities"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-perl/List-MoreUtils"
DEPEND="${RDEPEND}"
