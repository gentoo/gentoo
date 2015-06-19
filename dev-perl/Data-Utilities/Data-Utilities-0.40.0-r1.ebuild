# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Utilities/Data-Utilities-0.40.0-r1.ebuild,v 1.1 2014/08/26 16:08:23 axs Exp $

EAPI=5

MODULE_AUTHOR=CORNELIS
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Merge nested Perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Clone"
RDEPEND="${DEPEND}"

SRC_TEST=do
PREFER_BUILDPL=no
