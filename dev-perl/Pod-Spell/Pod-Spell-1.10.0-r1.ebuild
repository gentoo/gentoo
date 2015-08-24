# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SBURKE
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="A formatter for spellchecking Pod"
SRC_URI+=" mirror://gentoo/podspell.1.gz https://dev.gentoo.org/~tove/files/podspell.1.gz"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="virtual/perl-Pod-Escapes
	virtual/perl-Pod-Parser"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_install() {
	perl-module_src_install
	doman "${WORKDIR}"/podspell.1 || die
}
