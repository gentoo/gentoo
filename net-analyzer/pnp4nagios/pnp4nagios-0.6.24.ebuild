# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit depend.apache eutils

DESCRIPTION="A performance data analyzer for nagios"
HOMEPAGE="http://www.pnp4nagios.org"
SRC_URI="mirror://sourceforge/${PN}/PNP-0.6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

DEPEND="
	dev-lang/php[json,simplexml,zlib,xml,filter]
	>=dev-lang/php-5.3
	>=net-analyzer/rrdtool-1.2[graph,perl]
	|| ( net-analyzer/nagios-core net-analyzer/icinga net-analyzer/icinga2 )"
RDEPEND="${DEPEND}
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes
	media-fonts/dejavu
	apache2? ( www-servers/apache[apache2_modules_rewrite] )"

want_apache2

pkg_setup() {
	depend.apache_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.14-makefile.patch
}

src_configure() {
	local var_dir=
	local user_group=

	if has_version net-analyzer/nagios-core; then
		var_dir=/var/nagios/
		user_group=nagios
	else
		var_dir=/var/lib/icinga/
		user_group=icinga
	fi

	econf \
		--sysconfdir=/etc/pnp \
		--datarootdir=/usr/share/pnp \
		--mandir=/usr/share/man \
		--with-perfdata-dir=${var_dir}/perfdata \
		--with-nagios-user=${user_group} \
		--with-nagios-group=${user_group} \
		--with-perfdata-logfile=${var_dir}/perfdata.log \
		--with-perfdata-spool-dir=/var/spool/pnp
}

src_compile() {
	# The default target just shows a help
	emake all
}

src_install() {
	emake DESTDIR="${D}" install install-config
	newinitd "${FILESDIR}"/npcd.initd npcd
	rm "${D}"/usr/share/pnp/install.php || die

	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR}"
		doins "${FILESDIR}"/98_pnp4nagios.conf
	fi

	# Bug 430358 - CVE-2012-3457
	find "${D}/etc/pnp" -type f -exec chmod 0640 {} \; || die
	find "${D}/etc/pnp" -type d -exec chmod 0750 {} \; || die
}

pkg_postinst() {
	elog "Please make sure to enable URL rewriting in Apache or any other"
	elog "webserver you're using, to get pnp4nagios running!"
}
