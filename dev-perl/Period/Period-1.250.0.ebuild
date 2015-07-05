# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Period/Period-1.250.0.ebuild,v 1.1 2015/07/05 20:47:30 zlogene Exp $

EAPI=5

MY_PN=Time-Period
MODULE_AUTHOR=PBOYD
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Time period Perl module"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

SRC_TEST=do
