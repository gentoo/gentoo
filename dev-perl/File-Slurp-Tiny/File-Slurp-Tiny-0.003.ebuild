# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Slurp-Tiny/File-Slurp-Tiny-0.003.ebuild,v 1.1 2015/03/13 17:27:26 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.003
inherit perl-module

DESCRIPTION="A simple, sane and efficient file slurper"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
