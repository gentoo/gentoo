# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-VecStat/Math-VecStat-0.80.0-r1.ebuild,v 1.1 2014/08/22 19:36:07 axs Exp $

EAPI=5

MODULE_AUTHOR=ASPINELLI
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Some basic numeric stats on vectors"

SLOT="0"
KEYWORDS="amd64 ia64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

SRC_TEST="do"
