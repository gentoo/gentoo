# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Term-ShellUI/Term-ShellUI-0.920.0-r1.ebuild,v 1.1 2014/08/26 19:22:28 axs Exp $

EAPI=5

MODULE_AUTHOR=BRONSON
MODULE_VERSION=0.92
inherit perl-module

DESCRIPTION="A fully-featured shell-like command line environment"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/Term-ReadLine-Gnu"

SRC_TEST=do
