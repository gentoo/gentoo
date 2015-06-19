# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-Mail/DateTime-Format-Mail-0.300.100-r1.ebuild,v 1.3 2015/06/13 22:25:17 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.3001
inherit perl-module

DESCRIPTION="Convert between DateTime and RFC2822/822 formats"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/Params-Validate-0.67
		>=dev-perl/DateTime-0.17"
DEPEND="${RDEPEND}
		dev-perl/Module-Build"

SRC_TEST="do"
