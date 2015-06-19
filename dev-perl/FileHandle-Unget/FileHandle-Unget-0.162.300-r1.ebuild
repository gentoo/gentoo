# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/FileHandle-Unget/FileHandle-Unget-0.162.300-r1.ebuild,v 1.2 2013/12/15 12:58:13 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DCOPPIT
MODULE_VERSION=0.1623
inherit perl-module versionator

DESCRIPTION="A FileHandle which supports ungetting of multiple bytes"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE=""

SRC_TEST=do
