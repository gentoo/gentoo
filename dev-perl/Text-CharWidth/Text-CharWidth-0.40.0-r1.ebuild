# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-CharWidth/Text-CharWidth-0.40.0-r1.ebuild,v 1.1 2014/08/22 18:24:40 axs Exp $

EAPI=5

MODULE_AUTHOR=KUBOTA
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Get number of occupied columns of a string on terminal"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
