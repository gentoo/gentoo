# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_Server/PEAR-Net_Server-1.0.2-r1.ebuild,v 1.8 2014/08/10 20:53:15 slyfox Exp $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Generic server class for PHP"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-lang/php[sockets]"

pkg_postinst() {
	if ! has_version "dev-lang/php[pcntl]" ; then
		elog "${PN} can optionally use dev-lang/php pcntl features."
		elog "If you want those, recompile dev-lang/php with this flag in USE."
	fi
}
