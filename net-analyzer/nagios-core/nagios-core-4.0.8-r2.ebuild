# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit depend.apache eutils multilib toolchain-funcs user

MY_P=${PN/-core}-${PV}
DESCRIPTION="Nagios Core - Check daemon, CGIs, docs"
HOMEPAGE="http://www.nagios.org/"

# The name of the directory into which our Gentoo icons will be
# extracted, and also the basename of the archive containing it.
GENTOO_ICONS="${PN}-gentoo-icons-20141125"
SRC_URI="mirror://sourceforge/nagios/${MY_P}.tar.gz
	web? ( https://dev.gentoo.org/~mjo/distfiles/${GENTOO_ICONS}.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="classicui lighttpd perl +web vim-syntax"

# In pkg_postinst(), we change the group of the Nagios configuration
# directory to that of the web server user. It can't belong to both
# apache/lighttpd groups at the same time, so we block this combination
# for our own sanity.
#
# This could be made to work, but we would need a better way to allow
# the web user read-only access to Nagios's configuration directory.
#
REQUIRED_USE="apache2? ( !lighttpd )"

# A list of modules used in our Apache config file.
APACHE_MODS="apache2_modules_alias,"       # "Alias" directive
APACHE_MODS+="apache2_modules_authz_core" # "Require" directive

# Note, we require one of the apache2 CGI modules:
#
#   * mod_cgi
#   * mod_cgid
#   * mod_fcgid
#   * mod_proxy_fcgi
#
# We just don't care /which/ one. And of course PHP supports both CGI
# (USE=cgi) and FastCGI (USE=fpm) as well as mod_php (USE=apache2).
#
# Note: trying to move the base apache dep into DEPEND and build upon it
# caused problems.
#
# The first group corresponds to PHP running under Apache's mod_php.
PHP_MOD="( >=www-servers/apache-2.4[${APACHE_MODS}]
	dev-lang/php[apache2] )"

# The second is for PHP running through CGI with mod_cgi or mod_cgid.
PHP_CGI="( || ( >=www-servers/apache-2.4[${APACHE_MODS},apache2_modules_cgi]
				>=www-servers/apache-2.4[${APACHE_MODS},apache2_modules_cgid] )
	dev-lang/php[cgi] )"

# This one's for running PHP through CGI with mod_fcgid.
PHP_FCGID="( >=www-servers/apache-2.4[${APACHE_MODS}]
	www-apache/mod_fcgid
	dev-lang/php[cgi] )"

# And the last one is for running PHP through mod_proxy_fcgi.
PHP_FPM="( >=www-servers/apache-2.4[${APACHE_MODS},apache2_modules_proxy_fcgi]
	dev-lang/php[fpm] )"

DEPEND="dev-libs/libltdl
	virtual/mailx
	perl? ( dev-lang/perl )
	web? ( media-libs/gd[jpeg,png]
			lighttpd? ( www-servers/lighttpd[php] )
			apache2? ( || ( ${PHP_MOD} ${PHP_CGI} ${PHP_FCGID} ${PHP_FPM} ) ) )"

RDEPEND="${DEPEND}
	!net-analyzer/nagios-imagepack
	vim-syntax? ( app-vim/nagios-syntax )"

want_apache2

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	depend.apache_pkg_setup

	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_prepare(){
	# Upstream bug, fixes a QA warning:
	#
	#  http://tracker.nagios.org/view.php?id=650
	#
	epatch "${FILESDIR}"/use-MAKE-instead-of-bare-make.patch

	# Upstream bug:
	#
	# http://tracker.nagios.org/view.php?id=651
	#
	# Gentoo bug #388321.
	#
	epatch "${FILESDIR}"/use-INSTALL-to-install-themes.patch

	# Upstream bug:
	#
	# http://tracker.nagios.org/view.php?id=534
	#
	# Gentoo bug #530640.
	epatch "${FILESDIR}"/fix-bogus-perf-data-warnings.patch
}

src_configure() {
	local myconf

	if use perl; then
		myconf="${myconf} --enable-embedded-perl --with-perlcache"
	fi

	if use !apache2 && use !lighttpd ; then
		myconf="${myconf} --with-command-group=nagios"
	else
		if use apache2 ; then
			myconf="${myconf} --with-command-group=apache"
			myconf="${myconf} --with-httpd-conf=/etc/apache2/conf.d"
		elif use lighttpd ; then
			myconf="${myconf} --with-command-group=lighttpd"
		fi
	fi

	econf ${myconf} \
		--prefix=/usr \
		--bindir=/usr/sbin \
		--sbindir=/usr/$(get_libdir)/nagios/cgi-bin \
		--datadir=/usr/share/nagios/htdocs \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins
}

src_compile() {
	emake CC=$(tc-getCC) nagios

	if use web; then
		# Only compile the CGIs when USE=web is set.
		emake CC=$(tc-getCC) DESTDIR="${D}" cgis
	fi
}

src_install() {
	dodoc Changelog INSTALLING LEGAL README.asciidoc UPGRADING

	emake DESTDIR="${D}" install-base
	emake DESTDIR="${D}" install-basic
	emake DESTDIR="${D}" install-config
	emake DESTDIR="${D}" install-commandmode

	if use web; then
		emake DESTDIR="${D}" install-cgis

		# install-html installs the new exfoliation theme
		emake DESTDIR="${D}" install-html

		if use classicui; then
			# This overwrites the already-installed exfoliation theme
			emake DESTDIR="${D}" install-classicui
		fi

		# Install cute Gentoo icons (bug #388323), setting their
		# owner, group, and mode to match those of the rest of Nagios's
		# images.
		insopts --group=nagios --owner=nagios --mode=0664
		insinto /usr/share/nagios/htdocs/images/logos
		doins "${WORKDIR}/${GENTOO_ICONS}"/*.*
		insopts --mode=0644 # Back to the default...
	fi

	newinitd "${FILESDIR}"/nagios4 nagios
	newconfd "${FILESDIR}"/conf.d nagios

	if use web ; then
		if use apache2 ; then
			# Install the Nagios configuration file for Apache.
			insinto "${APACHE_MODULES_CONFDIR}"
			doins "${FILESDIR}"/99_nagios4.conf
		elif use lighttpd ; then
			# Install the Nagios configuration file for Lighttpd.
			insinto /etc/lighttpd
			newins "${FILESDIR}/lighttpd_nagios4.conf" nagios.conf
		else
			ewarn "${CATEGORY}/${PF} only supports apache or lighttpd"
			ewarn "out of the box. Since you are not using one of them, you"
			ewarn "will have to configure your webserver yourself."
		fi
	fi

	for dir in etc/nagios var/nagios ; do
		chown -R nagios:nagios "${D}/${dir}" \
			|| die "failed chown of ${D}/${dir}"
	done

	chown -R root:root "${D}/usr/$(get_libdir)/nagios" \
		|| die "failed chown of ${D}/usr/$(get_libdir)/nagios"

	# The following two find...exec statements will die properly as long
	# as chmod is only called once (that is, as long as the argument
	# list is small enough).
	find "${D}/usr/$(get_libdir)/nagios" -type d \
		-exec chmod 755 '{}' + || die 'failed to make nagios dirs traversable'

	if use web; then
		find "${D}/usr/$(get_libdir)/nagios/cgi-bin" -type f \
			-exec chmod 755 '{}' + || die 'failed to make cgi-bins executable'
	fi

	keepdir /etc/nagios
	keepdir /var/nagios
	keepdir /var/nagios/archives
	keepdir /var/nagios/rw
	keepdir /var/nagios/spool/checkresults

	if use !apache2 && use !lighttpd; then
		chown -R nagios:nagios "${D}"/var/nagios/rw \
			|| die "failed chown of ${D}/var/nagios/rw"
	else
		if use apache2 ; then
			chown -R nagios:apache "${D}"/var/nagios/rw \
				|| die "failed chown of ${D}/var/nagios/rw"
		elif use lighttpd ; then
			chown -R nagios:lighttpd "${D}"/var/nagios/rw \
				|| die "failed chown of ${D}/var/nagios/rw"
		fi
	fi

	chmod ug+s "${D}"/var/nagios/rw || die "failed chmod of ${D}/var/nagios/rw"
	chmod 0750 "${D}"/etc/nagios || die "failed chmod of ${D}/etc/nagios"
}

pkg_postinst() {

	if use web; then
		elog "Note that your web server user requires read-only access to"
		elog "${ROOT}etc/nagios."

		if use apache2 || use lighttpd ; then
			elog
			elog "To that end, we have changed the group of ${ROOT}etc/nagios"
			elog "to that of your web server user."
			elog
			if use apache2; then
				chown nagios:apache "${ROOT}etc/nagios" \
					|| die "failed to change group of ${ROOT}etc/nagios"

				elog "To enable the Nagios web front-end, please edit"
				elog "${ROOT}etc/conf.d/apache2 and add \"-D NAGIOS -D PHP5\""
				elog "to APACHE2_OPTS. Then Nagios will be available at,"
				elog
			elif use lighttpd; then
				chown nagios:lighttpd "${ROOT}etc/nagios" \
					|| die "failed to change group of ${ROOT}etc/nagios"
				elog "To enable the Nagios web front-end, please add"
				elog "'include \"nagios.conf\"' to the lighttpd configuration"
				elog "file at ${ROOT}etc/lighttpd/lighttpd.conf. Then Nagios"
				elog "will be available at,"
				elog
			fi

			elog "  http://localhost/nagios/"
		else
			elog "Since you're not using either Apache or Lighttpd, you"
			elog "will have to grant the necessary permissions yourself."
		fi
	fi

	elog
	elog "If your kernel has /proc protection, nagios"
	elog "will not be happy as it relies on accessing the proc"
	elog "filesystem. You can fix this by adding nagios into"
	elog "the group wheel, but this is not recomended."
	elog
}
