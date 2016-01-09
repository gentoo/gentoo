# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Perl-Tidy
MODULE_AUTHOR=SHANCOCK
MODULE_VERSION=20140711
inherit perl-module

DESCRIPTION="Perl script indenter and beautifier"
HOMEPAGE="http://perltidy.sourceforge.net/ ${HOMEPAGE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"

src_install() {
	perl-module_src_install
	docinto examples
	dodoc "${S}"/examples/*
}
