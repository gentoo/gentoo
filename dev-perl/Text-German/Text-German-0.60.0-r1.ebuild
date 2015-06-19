# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-German/Text-German-0.60.0-r1.ebuild,v 1.1 2014/08/22 18:25:29 axs Exp $

EAPI=5

MODULE_AUTHOR=ULPFR
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="German grundform reduction"

SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
