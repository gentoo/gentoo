# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A performance data analyzer for nagios"
HOMEPAGE="http://www.pnp4nagios.org/"
SRC_URI="mirror://sourceforge/${PN}/PNP-0.6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="apache2 icinga icinga2 +nagios"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

REQUIRED_USE="^^ ( icinga icinga2 nagios )"

# Some things (sync mode, for one) are broken with nagios-4.x, but since
# nagios-3.x has been end-of-life'd, we don't have much choice here but
# to accept it.
DEPEND="
	dev-lang/php:*[filter,gd,json,simplexml,xml,zlib]
	>=net-analyzer/rrdtool-1.2[graph,perl]
	icinga? ( net-analyzer/icinga )
	icinga2? ( net-analyzer/icinga2 )
	nagios? ( net-analyzer/nagios-core )"

# A list of modules used in our Apache config file.
APACHE_MODS="apache2_modules_alias,"       # "Alias" directive
APACHE_MODS+="apache2_modules_authz_core," # "Require" directive
APACHE_MODS+="apache2_modules_rewrite"     # "RewriteEngine" and friends

RDEPEND="${DEPEND}
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes
	media-fonts/dejavu
	apache2? ( >=www-servers/apache-2.4[${APACHE_MODS}] )"

PATCHES=( "${FILESDIR}/${PN}-0.6.14-makefile.patch" )

src_configure() {
	local var_dir user_group

	if use icinga; then
		var_dir=/var/lib/icinga
		user_group=icinga
	elif use icinga2; then
		var_dir=/var/lib/icinga2
		user_group=icinga
	else
		# Thanks to REQUIRED_USE, "use nagios" is the only other case.
		var_dir=/var/nagios
		user_group=nagios
	fi

	econf \
		--sysconfdir="${EPREFIX}"/etc/pnp \
		--datarootdir="${EPREFIX}"/usr/share/pnp \
		--with-perfdata-dir="${EPREFIX}"${var_dir}/perfdata \
		--with-nagios-user=${user_group} \
		--with-nagios-group=${user_group} \
		--with-perfdata-logfile="${EPREFIX}"${var_dir}/perfdata.log \
		--with-perfdata-spool-dir="${EPREFIX}"/var/spool/pnp
}

src_compile() {
	# The default target just shows a help
	emake all
}

src_install() {
	emake DESTDIR="${D}" install install-config
	einstalldocs
	newinitd "${FILESDIR}"/npcd.initd npcd
	rm "${ED%/}/usr/share/pnp/install.php" || \
		die "unable to remove ${ED%/}/usr/share/pnp/install.php"

	# Fix CVE-2012-3457 (Gentoo bug 430358)
	fperms o-rwx /etc/pnp/process_perfdata.cfg

	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR}"
		newins "${FILESDIR}"/98_pnp4nagios-2.4.conf 98_pnp4nagios.conf

		# This one file isn't world-readable, but it should be group-
		# readable. Give it to the "apache" group to let the web
		# server read it.
		fowners :apache /etc/pnp/process_perfdata.cfg
	fi
}

pkg_postinst() {
	elog "To enable the pnp4nagios web front-end, please visit"
	elog "${EROOT%/}/etc/conf.d/apache2 and add \"-D PNP -D PHP5\""
	elog "to APACHE2_OPTS. Then pnp4nagios will be available at,"
	elog
	elog "  http://localhost/pnp4nagios"
	elog
}
