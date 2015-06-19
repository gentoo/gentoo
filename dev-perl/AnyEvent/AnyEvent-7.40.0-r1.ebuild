# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AnyEvent/AnyEvent-7.40.0-r1.ebuild,v 1.1 2014/08/22 17:20:05 axs Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=7.04
inherit perl-module

DESCRIPTION="Provides a uniform interface to various event loops"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-solaris"
IUSE=""

SRC_TEST="do"
