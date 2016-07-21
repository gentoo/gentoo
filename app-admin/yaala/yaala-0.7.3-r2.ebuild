# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils perl-module

DESCRIPTION="Yet Another Log Analyzer"
HOMEPAGE="http://www.yaala.org/"
SRC_URI="http://www.${PN}.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gd"

RDEPEND="
	dev-lang/perl
	virtual/perl-Storable
	gd? ( dev-perl/GDGraph )
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.3-r1-correct-paths.patch

	sed -i "s:/var/lib/${PN}:/usr/bin:g" packaging/${PN}.cron || die 'Failed to correct path in cron file.'
}

src_install() {
	dobin ${PN}

	# Switch to ^y when we switch to EAPI=6.
	local mod="Y${PN:1}"

	perl_set_version

	insinto "${VENDOR_LIB}/${mod}/"
	doins lib/${mod}/*.pm

	insinto "${VENDOR_LIB}/${mod}/Data/"
	doins lib/${mod}/Data/*.pm

	insinto "${VENDOR_LIB}/${mod}/Parser/"
	doins lib/${mod}/Parser/*.pm

	insinto "${VENDOR_LIB}/${mod}/Report/"
	doins lib/${mod}/Report/*.pm

	dodoc AUTHORS CHANGELOG README{,.persistency,.selections}

	insinto /usr/share/${PN}
	doins -r reports
	doins -r sample_configs

	insinto /etc/${PN}
	doins {,webserver.}config

	insinto /etc/logrotate.d
	doins packaging/${PN}.cron

	keepdir /var/lib/${PN}
	fperms 777 /var/lib/${PN}
}

pkg_postinst() {
	ewarn "It is required that you change the configuration files in /etc/${PN}"
	ewarn "before you run \`yaala ...\`, otherwise it will refuse to execute because"
	ewarn "Setup.pm checks whether the variable 'select' has been unquoted and set."
	echo ""
	elog "Example configuration files can be found in /usr/share/${PN}."
}
