# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/News-Newsrc/News-Newsrc-1.90.0-r1.ebuild,v 1.1 2014/08/23 00:21:18 axs Exp $

EAPI=5

MODULE_AUTHOR=SWMCD
MODULE_VERSION=1.09
inherit perl-module

DESCRIPTION="Manage newsrc files"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc x86"
IUSE=""

RDEPEND=">=dev-perl/Set-IntSpan-1.07"
DEPEND="${RDEPEND}"

SRC_TEST="do"
