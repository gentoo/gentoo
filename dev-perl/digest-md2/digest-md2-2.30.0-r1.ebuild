# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/digest-md2/digest-md2-2.30.0-r1.ebuild,v 1.1 2014/08/22 15:55:33 axs Exp $

EAPI=5

MY_PN=Digest-MD2
MODULE_AUTHOR=GAAS
MODULE_VERSION=2.03
inherit perl-module

DESCRIPTION="Perl interface to the MD2 Algorithm"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

SRC_TEST=do
