# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.09
inherit perl-module

DESCRIPTION="Track the number of times subs are called"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND=">=dev-perl/Hook-LexWrap-0.20
	virtual/perl-File-Spec"
RDEPEND="${DEPEND}"

SRC_TEST="do"
