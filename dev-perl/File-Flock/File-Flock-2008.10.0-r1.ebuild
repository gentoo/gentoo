# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Flock/File-Flock-2008.10.0-r1.ebuild,v 1.1 2014/08/22 17:53:59 axs Exp $

EAPI=5

MODULE_AUTHOR=MUIR
MODULE_VERSION=2008.01
MODULE_SECTION=modules
inherit perl-module

DESCRIPTION="flock() wrapper.  Auto-create locks"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
