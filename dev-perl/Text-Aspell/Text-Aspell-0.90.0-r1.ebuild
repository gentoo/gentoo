# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HANK
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl interface to the GNU Aspell Library"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# Disabling tests for now - see bug #147897 --ian
#SRC_TEST="do"

RDEPEND="app-text/aspell"
DEPEND="${RDEPEND}"
