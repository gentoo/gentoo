# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=THOR
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~m68k ~mips ppc ppc64 s390 sh x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="net-dns/libidn"
RDEPEND="${DEPEND}"

SRC_TEST=do
