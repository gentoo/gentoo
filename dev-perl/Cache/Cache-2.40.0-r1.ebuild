# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cache/Cache-2.40.0-r1.ebuild,v 1.1 2014/08/23 21:31:53 axs Exp $

EAPI=5

MODULE_AUTHOR=CLEISHMAN
MODULE_VERSION=2.04
inherit perl-module

DESCRIPTION="the Cache interface"

RDEPEND=">=virtual/perl-DB_File-1.72
	>=virtual/perl-File-Spec-0.8
	>=virtual/perl-Storable-1
	>=dev-perl/Digest-SHA1-2.01
	dev-perl/Heap
	>=dev-perl/IO-String-1.02
	dev-perl/TimeDate
	dev-perl/File-NFSLock"
DEPEND="${RDEPEND}"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_TEST="do"
