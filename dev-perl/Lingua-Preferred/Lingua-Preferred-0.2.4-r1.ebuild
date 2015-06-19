# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-Preferred/Lingua-Preferred-0.2.4-r1.ebuild,v 1.2 2013/12/09 12:16:44 zlogene Exp $

EAPI=5

MODULE_AUTHOR=EDAVIS
inherit perl-module

DESCRIPTION="Pick a language based on user's preferences"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 GPL-3 )" # GPL-2+
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-perl/Log-TraceMessages"
DEPEND="${RDEPEND}"

SRC_TEST="do parallel"
