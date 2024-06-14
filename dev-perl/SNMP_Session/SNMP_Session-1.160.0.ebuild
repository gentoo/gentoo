# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SKIM
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="A SNMP Perl Module"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 sparc x86"

src_install() {
	perl-module_src_install
	docinto html
	dodoc index.html
}
