# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PDF-Create/PDF-Create-1.60.0-r1.ebuild,v 1.2 2015/06/13 22:30:31 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MARKUSB
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="PDF::Create allows you to create PDF documents"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="dev-perl/Module-Build"

SRC_TEST=do
