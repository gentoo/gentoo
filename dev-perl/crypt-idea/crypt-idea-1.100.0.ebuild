# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-idea/crypt-idea-1.100.0.ebuild,v 1.11 2014/03/19 20:43:11 zlogene Exp $

EAPI=5

MY_PN=Crypt-IDEA
MODULE_AUTHOR=DPARIS
MODULE_VERSION=1.10
inherit perl-module

DESCRIPTION="Parse and save PGP packet streams"

LICENSE="Crypt-IDEA"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

SRC_TEST="do"
