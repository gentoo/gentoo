# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/inline-files/inline-files-0.680.0-r1.ebuild,v 1.1 2014/08/22 19:25:16 axs Exp $

EAPI=5

MY_PN=Inline-Files
MODULE_AUTHOR=AMBS
MODULE_SECTION=Inline
MODULE_VERSION=0.68
inherit perl-module

DESCRIPTION="Multiple virtual files in a single file"

SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

SRC_TEST=do
