# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-Depends/ExtUtils-Depends-0.308.0.ebuild,v 1.1 2015/05/01 11:43:29 dilfridge Exp $

EAPI=5

MY_PN=ExtUtils-Depends
MODULE_AUTHOR=XAOC
MODULE_VERSION=0.308
inherit perl-module

DESCRIPTION="Easily build XS extensions that depend on XS extensions"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

SRC_TEST="do parallel"
