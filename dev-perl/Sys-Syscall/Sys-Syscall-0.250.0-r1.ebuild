# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sys-Syscall/Sys-Syscall-0.250.0-r1.ebuild,v 1.1 2014/08/22 18:21:09 axs Exp $

EAPI=5

MODULE_AUTHOR=BRADFITZ
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Access system calls that Perl doesn't normally provide access to"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

SRC_TEST="do"
