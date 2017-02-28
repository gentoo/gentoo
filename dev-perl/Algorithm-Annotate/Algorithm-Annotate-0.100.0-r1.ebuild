# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CLKAO
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Represent a series of changes in annotate form"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=">=dev-perl/Algorithm-Diff-1.150.0"
DEPEND="${RDEPEND}"

SRC_TEST="do"
