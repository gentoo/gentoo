# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit depend.apache eutils

DESCRIPTION="A performance data analyzer for nagios"
HOMEPAGE="http://www.pnp4nagios.org/"
SRC_URI="mirror://sourceforge/${PN}/PNP-0.6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

# A lot of things (sync mode, for one) are broken with nagios-4.x.
DEPEND="
	>=dev-lang/php-5.3:*[json,simplexml,zlib,xml,filter]
	>=net-analyzer/rrdtool-1.2[graph,perl]
	|| ( <net-analyzer/nagios-core-4 net-analyzer/icinga net-analyzer/icinga2 )"

# A list of modules used in our Apache config file.
APACHE_MODS="apache2_modules_alias,"       # "Alias" directive
APACHE_MODS+="apache2_modules_authz_core," # "Require" directive
APACHE_MODS+="apache2_modules_rewrite"     # "RewriteEngine" and friends

RDEPEND="${DEPEND}
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes
	media-fonts/dejavu
	apache2? ( >=www-servers/apache-2.4[${APACHE_MODS}] )"

# There is no want_apache2_4, but we needed to specify that manually
# anyway to be able to include the list of modules.
want_apache2

pkg_setup() {
	depend.apache_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.6.14-makefile.patch"
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
	rm "${D}/usr/share/pnp/install.php" || \
		die "unable to remove ${D}/usr/share/pnp/install.php"

	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR}"
		newins "${FILESDIR}"/98_pnp4nagios-2.4.conf 98_pnp4nagios.conf

		# Allow the apache user to read our config files. This same
		# approach is used in net-analyzer/nagios-core.
		chgrp -R apache "${D}/etc/pnp" \
			|| die "failed to change group of ${ROOT}etc/pnp"
	fi

	# Bug 430358 - CVE-2012-3457
	find "${D}/etc/pnp" -type f -exec chmod 0640 '{}' + || \
		die "unable to set file permissions under ${D}/etc/pnp"

	find "${D}/etc/pnp" -type d -exec chmod 0750 '{}' + || \
		die "unable to set directory permissions under ${D}/etc/pnp"
}

pkg_postinst() {
	elog "To enable the pnp4nagios web front-end, please visit"
	elog "${ROOT}etc/conf.d/apache2 and add \"-D PNP -D PHP5\""
	elog "to APACHE2_OPTS. Then pnp4nagios will be available at,"
	elog
	elog "  http://localhost/pnp4nagios"
	elog
}
