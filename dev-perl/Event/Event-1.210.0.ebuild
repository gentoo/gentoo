# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Event/Event-1.210.0.ebuild,v 1.2 2014/06/13 11:44:53 zlogene Exp $

EAPI=5

MODULE_AUTHOR=JPRIT
MODULE_VERSION=1.21
inherit perl-module

DESCRIPTION="fast, generic event loop"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-solaris"
IUSE=""

SRC_TEST="do"

mydoc="ANNOUNCE INSTALL TODO Tutorial.pdf"
