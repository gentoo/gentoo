# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Yet Another Log Analyzer"
HOMEPAGE="http://www.yaala.org/"
SRC_URI="http://www.${PN}.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gd storable"

RDEPEND="dev-lang/perl
	gd? ( dev-perl/GDGraph )
	storable? ( virtual/perl-Storable )"

src_prepare() {
	epatch "${FILESDIR}"/${PF}-correct-paths.patch

	sed -i "s:/var/lib/${PN}:/usr/bin:g" packaging/${PN}.cron || die 'Failed to correct path in cron file.'
}

src_install() {
	dobin ${PN}

	# Switch to ^y when we switch to EAPI=6.
	local mod="Y${PN:1}"

	exeinto /usr/lib64/perl5/vendor_perl/${mod}/
	doexe lib/${mod}/*.pm

	exeinto /usr/lib64/perl5/vendor_perl/${mod}/Data/
	doexe lib/${mod}/Data/*.pm

	exeinto /usr/lib64/perl5/vendor_perl/${mod}/Parser/
	doexe lib/${mod}/Parser/*.pm

	exeinto /usr/lib64/perl5/vendor_perl/${mod}/Report/
	doexe lib/${mod}/Report/*.pm

	dodoc AUTHORS CHANGELOG README{,.persistency,.selections}

	insinto /usr/share/${PN}
	doins -r reports
	doins -r sample_configs

	insinto /etc/${PN}
	doins {,webserver.}config

	insinto /etc/logrotate.d
	doins packaging/${PN}.cron

	if use storable ; then
		dodir /var/lib/${PN}
		keepdir /var/lib/${PN}
		chmod 777 /var/lib/${PN}
	fi
}

pkg_postinst() {
	ewarn "It is required that you change the configuration files in /etc/${PN}"
	ewarn "before you run \`yaala ...\`, otherwise it will refuse to execute because"
	ewarn "Setup.pm checks whether the variable 'select' has been unquoted and set."
	echo ""
	elog "Example configuration files can be found in /usr/share/${PN}."
}
