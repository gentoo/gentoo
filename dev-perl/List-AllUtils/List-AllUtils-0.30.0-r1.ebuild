# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/List-AllUtils/List-AllUtils-0.30.0-r1.ebuild,v 1.1 2014/08/26 17:06:20 axs Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION='Combines List::Util and List::MoreUtils in one bite-sized package'

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/List-MoreUtils-0.280.0
	>=virtual/perl-Scalar-List-Utils-1.190.0
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
