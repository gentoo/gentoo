# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-NCopy/File-NCopy-0.360.0-r1.ebuild,v 1.1 2014/08/23 00:11:40 axs Exp $

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=0.36
inherit perl-module

DESCRIPTION="Copy file, file Copy file[s] | dir[s], dir"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="virtual/perl-File-Spec"
DEPEND="${RDEPEND}"
