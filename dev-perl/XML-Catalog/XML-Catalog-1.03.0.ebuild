# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Catalog/XML-Catalog-1.03.0.ebuild,v 1.2 2015/06/13 22:53:03 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JFEARN
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="Resolve public identifiers and remap system identifiers"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/XML-Parser
	>=dev-perl/libwww-perl-5.48"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
