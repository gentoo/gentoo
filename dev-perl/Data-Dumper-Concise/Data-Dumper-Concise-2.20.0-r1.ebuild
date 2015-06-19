# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Dumper-Concise/Data-Dumper-Concise-2.20.0-r1.ebuild,v 1.1 2014/08/26 14:47:21 axs Exp $

EAPI=5

MODULE_AUTHOR=FREW
MODULE_VERSION=2.020
inherit perl-module

DESCRIPTION="Less indentation and newlines plus sub deparsing"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix ~x86-solaris"
IUSE=""

#RDEPEND="dev-perl/Devel-ArgNames"
RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST=do
