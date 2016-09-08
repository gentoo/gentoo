# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CLEISHMAN
MODULE_VERSION=2.04
inherit perl-module

DESCRIPTION="the Cache interface"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/perl-DB_File-1.72
	>=virtual/perl-File-Spec-0.8
	>=virtual/perl-Storable-1
	>=dev-perl/Digest-SHA1-2.01
	dev-perl/Heap
	>=dev-perl/IO-String-1.02
	dev-perl/TimeDate
	dev-perl/File-NFSLock"
DEPEND="${RDEPEND}"

SRC_TEST="do"
