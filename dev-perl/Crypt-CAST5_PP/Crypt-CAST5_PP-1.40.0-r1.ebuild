# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-CAST5_PP/Crypt-CAST5_PP-1.40.0-r1.ebuild,v 1.1 2014/08/22 17:41:51 axs Exp $

EAPI=5

MODULE_AUTHOR=BOBMATH
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="CAST5 block cipher in pure Perl"

SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

SRC_TEST="do"
