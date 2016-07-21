# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
MODULE_AUTHOR=AMW
MODULE_VERSION=0.5
inherit perl-module

DESCRIPTION="Read directives from a configuration file"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

src_install() {
	perl_set_version
	insinto ${VENDOR_LIB}/${PN}
	doins "${S}"/*.pm || die
	insinto ${VENDOR_LIB}
	doins "${S}"/*.pod || die
	dodoc README || die
}
