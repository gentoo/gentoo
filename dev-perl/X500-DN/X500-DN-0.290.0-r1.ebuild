# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X500-DN/X500-DN-0.290.0-r1.ebuild,v 1.1 2014/08/24 01:21:22 axs Exp $

EAPI=5

MODULE_AUTHOR=RJOOP
MODULE_VERSION=0.29
inherit perl-module
DESCRIPTION="handle X.500 DNs (Distinguished Names), parse and format them"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86"
IUSE=""

RDEPEND="dev-perl/Parse-RecDescent"
DEPEND="${RDEPEND}"

SRC_TEST="do"
export OPTIMIZE="${CFLAGS}"
