# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit php-pear-r1

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"

DESCRIPTION="The Log framework provides an abstracted logging system.@"
LICENSE="MIT"
SLOT="0"
IUSE="minimal"

RDEPEND="!minimal? ( >=dev-php/PEAR-DB-1.7.6-r1
	dev-php/PEAR-Mail
	>=dev-php/PEAR-MDB2-2.0.0_rc1 )"

pkg_postinst() {
	if ! use minimal && ! has_version dev-lang/php[sqlite] ; then
		elog "${PN} can optionally use dev-lang/php's sqlite features."
		elog "If you want those, recompile dev-lang/php with this flag in USE."
	fi
}
