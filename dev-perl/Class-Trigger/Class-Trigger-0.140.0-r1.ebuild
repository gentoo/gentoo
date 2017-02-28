# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="Mixin to add / call inheritable triggers"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/IO-stringy"
DEPEND="${RDEPEND}"

SRC_TEST="do"
