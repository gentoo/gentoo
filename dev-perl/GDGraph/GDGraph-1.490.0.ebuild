# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GDGraph/GDGraph-1.490.0.ebuild,v 1.1 2015/05/06 19:22:49 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RUZ
MODULE_VERSION=1.49
inherit perl-module

DESCRIPTION="Perl5 module to create charts using the GD module"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/GDTextUtil
	dev-perl/GD
	media-libs/gd"
DEPEND="${RDEPEND}"
