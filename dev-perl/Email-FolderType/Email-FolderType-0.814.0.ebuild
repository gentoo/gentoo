# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-FolderType/Email-FolderType-0.814.0.ebuild,v 1.2 2015/06/13 18:50:40 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.814
inherit perl-module

DESCRIPTION="Determine the type of a mail folder"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/Module-Pluggable"
DEPEND="${RDEPEND}"

SRC_TEST="do"
