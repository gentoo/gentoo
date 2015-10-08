# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Thoroughly testing objects via registered handlers"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="virtual/perl-File-Spec
	virtual/perl-Scalar-List-Utils
	virtual/perl-Test-Simple"
DEPEND="${RDEPEND}"

SRC_TEST="do"
