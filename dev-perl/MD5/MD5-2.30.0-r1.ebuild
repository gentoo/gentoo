# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MD5/MD5-2.30.0-r1.ebuild,v 1.1 2014/08/23 00:16:12 axs Exp $

EAPI=5

MODULE_AUTHOR=GAAS
MODULE_VERSION=2.03
inherit perl-module

DESCRIPTION="The Perl MD5 Module"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}"

SRC_TEST="do"
export OPTIMIZE="${CFLAGS}"
