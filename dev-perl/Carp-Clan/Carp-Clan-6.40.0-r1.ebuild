# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=STBEY
MODULE_VERSION=6.04
inherit perl-module

DESCRIPTION="Report errors from perspective of caller of a clan of modules"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Exception )"

SRC_TEST="do"
