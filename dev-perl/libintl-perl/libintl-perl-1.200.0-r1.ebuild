# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GUIDO
MODULE_VERSION=1.20
inherit perl-module

DESCRIPTION="High-Level Interface to Uniforum Message Translation"
HOMEPAGE="http://guido-flohr.net/projects/libintl-perl ${HOMEPAGE}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST=do

src_test() {
	if grep -q '^de_' <( locale -a ) ; then
		if grep -q '^de_AT$' <( locale -a ) ; then
			perl-module_src_test
		else
			ewarn "Skipping tests, known broken with de_ and without de_AT"
		fi
	else
		perl-module_src_test
	fi
}
