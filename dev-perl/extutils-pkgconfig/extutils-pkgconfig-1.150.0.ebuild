# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/extutils-pkgconfig/extutils-pkgconfig-1.150.0.ebuild,v 1.6 2015/04/05 02:24:45 vapier Exp $

EAPI=5

MY_PN=ExtUtils-PkgConfig
MODULE_AUTHOR=XAOC
MODULE_VERSION=1.15
inherit perl-module

DESCRIPTION="Simplistic perl interface to pkg-config"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

DEPEND="virtual/pkgconfig"

SRC_TEST="do"
