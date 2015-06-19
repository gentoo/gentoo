# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Slurp/File-Slurp-9999.190.0-r1.ebuild,v 1.1 2014/08/21 17:20:34 axs Exp $

EAPI=5

MODULE_AUTHOR=URI
MODULE_VERSION=9999.19
inherit perl-module

DESCRIPTION="Efficient Reading/Writing of Complete Files"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"

mydoc="extras/slurp_article.pod"
