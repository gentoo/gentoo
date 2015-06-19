# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Random/Math-Random-0.710.0-r1.ebuild,v 1.1 2014/08/22 18:12:32 axs Exp $

EAPI=5

MODULE_AUTHOR=GROMMEL
MODULE_VERSION=0.71
inherit perl-module

DESCRIPTION="Random Number Generators"

LICENSE="( || ( Artistic GPL-2 ) ) public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_TEST="do"
