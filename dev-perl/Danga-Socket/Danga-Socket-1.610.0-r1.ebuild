# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Danga-Socket/Danga-Socket-1.610.0-r1.ebuild,v 1.1 2014/08/22 21:23:59 axs Exp $

EAPI=5

MODULE_AUTHOR=BRADFITZ
MODULE_VERSION=1.61
inherit perl-module

DESCRIPTION="A non-blocking socket object; uses epoll()"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-perl/Sys-Syscall"
DEPEND="${RDEPEND}"

SRC_TEST="do"
