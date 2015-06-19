# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Rcs/Rcs-1.50.0-r1.ebuild,v 1.1 2014/08/21 18:45:05 axs Exp $

EAPI=5

MODULE_AUTHOR=CFRETER
MODULE_VERSION=1.05
inherit perl-module

DESCRIPTION="Perl bindings for Revision Control System"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-vcs/rcs"
DEPEND="${RDEPEND}"
