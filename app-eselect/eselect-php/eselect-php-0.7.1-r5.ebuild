# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit depend.apache systemd

DESCRIPTION="PHP eselect module"
HOMEPAGE="https://www.gentoo.org"
SRC_URI="https://dev.gentoo.org/~olemarkus/eselect-php/eselect-php-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="fpm apache2"

RDEPEND="app-admin/eselect"
S="${WORKDIR}"

want_apache

src_install() {
	mv eselect-php-${PV} php.eselect
	insinto /usr/share/eselect/modules/
	doins php.eselect

	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR#${EPREFIX}}"
		newins "${FILESDIR}/70_mod_php5.conf-apache2-r1" \
			"70_mod_php5.conf"
	fi

	if use fpm ; then
		newinitd "${FILESDIR}/php-fpm.init-r2" "php-fpm"
		systemd_dotmpfilesd "${FILESDIR}/php-fpm.conf"
		exeinto /usr/libexec
		doexe "${FILESDIR}/php-fpm-launcher"
	fi
}
