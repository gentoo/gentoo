# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Unidecode/Text-Unidecode-0.40.0-r1.ebuild,v 1.2 2014/10/18 19:20:39 vapier Exp $

EAPI=5

MODULE_AUTHOR=SBURKE
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="US-ASCII transliterations of Unicode text"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST=do
