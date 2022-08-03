# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A performance data analyzer for nagios"
HOMEPAGE="http://www.pnp4nagios.org/"
SRC_URI="mirror://sourceforge/${PN}/PNP-0.6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="apache2 icinga +nagios"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

REQUIRED_USE="^^ ( icinga nagios )"

# Some things (sync mode, for one) are broken with nagios-4.x, but since
# nagios-3.x has been end-of-life'd, we don't have much choice here but
# to accept it.
DEPEND="
	dev-lang/php:*[filter,gd,json(+),simplexml,xml,zlib]
	net-analyzer/rrdtool[graph,perl]
	icinga? ( net-analyzer/icinga2 )
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

PATCHES=(
	"${FILESDIR}/${PN}-0.6.14-makefile.patch"
	"${FILESDIR}/${PN}-0.6.26-magic-quotes.patch"
	"${FILESDIR}/${PN}-0.6.26-sizeof.patch"
)

src_configure() {
	local user_group=nagios
	use icinga && user_group=icinga

	econf \
		--sysconfdir="${EPREFIX}"/etc/pnp \
		--datarootdir="${EPREFIX}"/usr/share/pnp \
		--localstatedir="${EPREFIX}"/var/lib/pnp \
		--with-nagios-user="${user_group}" \
		--with-nagios-group="${user_group}" \
		--with-perfdata-logfile="${EPREFIX}"/var/log/pnp/process_perfdata.log
}

src_compile() {
	# The default target just shows a help
	emake all
}

src_install() {
	# Don't use INSTALL_OPTS because they set insecure permissions on
	# all of /etc/pnp (https://github.com/lingej/pnp4nagios/issues/140).
	emake INSTALL_OPTS="" DESTDIR="${D}" install install-config
	einstalldocs
	newinitd "${FILESDIR}"/npcd.initd npcd
	rm "${ED%/}/usr/share/pnp/install.php" || \
		die "unable to remove ${ED%/}/usr/share/pnp/install.php"

	# Fix CVE-2012-3457 (Gentoo bug 430358)
	fperms o-rwx /etc/pnp/process_perfdata.cfg

	if use apache2 ; then
		insinto /etc/apache2/modules.d
		newins "${FILESDIR}"/98_pnp4nagios-2.4.conf 98_pnp4nagios.conf
	fi

	# The nagios or icinga user needs to write performance data to the
	# perfdata-dir...
	local user_group=nagios
	use icinga && user_group=icinga
	fowners ":${user_group}" /var/lib/pnp/{,perfdata,spool}
	fperms g+rwx /var/lib/pnp/{,perfdata,spool}

	# and likewise for its logs...
	dodir /var/log/pnp
	fowners ":${user_group}" /var/log/pnp
	fperms g+rwx /var/log/pnp

	# and its statistics. This one is arguably the responsibility of the
	# build system, since process_perfdata.cfg refers to this location.
	dodir /var/lib/pnp/stats
	fowners ":${user_group}" /var/lib/pnp/stats
	fperms g+rwx /var/lib/pnp/stats
}

pkg_postinst() {
	elog "To enable the pnp4nagios web front-end, please visit"
	elog "${EROOT%/}/etc/conf.d/apache2 and add \"-D PNP -D PHP\""
	elog "to APACHE2_OPTS. Then pnp4nagios will be available at,"
	elog
	elog "  http://localhost/pnp4nagios"
	elog
}
