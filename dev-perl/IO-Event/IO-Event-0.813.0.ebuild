# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Event/IO-Event-0.813.0.ebuild,v 1.5 2014/11/03 19:58:22 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MUIR
MODULE_VERSION=0.813
MODULE_SECTION=modules
inherit perl-module

DESCRIPTION="Tied Filehandles for Nonblocking IO with Object Callbacks"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/Event
	dev-perl/List-MoreUtils
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}"
