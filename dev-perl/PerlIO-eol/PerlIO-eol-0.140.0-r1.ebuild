# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PerlIO-eol/PerlIO-eol-0.140.0-r1.ebuild,v 1.1 2014/08/22 19:47:57 axs Exp $

EAPI=5

MODULE_AUTHOR=AUDREYT
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="PerlIO::eol - PerlIO layer for normalizing line endings"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
