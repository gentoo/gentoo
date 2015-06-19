# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unix-Getrusage/Unix-Getrusage-0.030.0.ebuild,v 1.4 2014/06/30 08:12:09 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TAFFY
MODULE_VERSION=0.03

inherit perl-module

DESCRIPTION="Perl interface to the Unix getrusage system call"

SLOT="0"
KEYWORDS="amd64 ~mips x86"

SRC_TEST="do parallel"
