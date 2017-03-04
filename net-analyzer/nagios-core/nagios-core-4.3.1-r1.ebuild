# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs user

MY_P=${PN/-core}-${PV}
DESCRIPTION="Nagios core - monitoring daemon, web GUI, and documentation"
HOMEPAGE="http://www.nagios.org/"

# The name of the directory into which our Gentoo icons will be
# extracted, and also the basename of the archive containing it.
GENTOO_ICONS="${PN}-gentoo-icons-20141125"
SRC_URI="mirror://sourceforge/nagios/${MY_P}.tar.gz
	web? ( https://dev.gentoo.org/~mjo/distfiles/${GENTOO_ICONS}.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ppc ppc64 sparc x86"
IUSE="apache2 classicui lighttpd perl +web vim-syntax"

# In pkg_postinst(), we change the group of the Nagios configuration
# directory to that of the web server user. It can't belong to both
# apache/lighttpd groups at the same time, so we block this combination
# for our own sanity.
#
# This could be made to work, but we would need a better way to allow
# the web user read-only access to Nagios's configuration directory.
#
REQUIRED_USE="apache2? ( !lighttpd )"

# sys-devel/libtool dependency is bug #401237.
#
# Note, we require one of the apache2 CGI modules:
#
#   * mod_cgi
#   * mod_cgid
#   * mod_fcgid
#
# We just don't care /which/ one. And of course PHP supports both CGI
# (USE=cgi) and FastCGI (USE=fpm). We're pretty lenient with the
# dependencies, and expect the user not to do anything /too/
# stupid. (For example, installing Apache with only FastCGI support, and
# PHP with only CGI support.)
#
# Another annoyance is that the upstream Makefile uses app-arch/unzip to
# extract a snapshot of AngularJS, but that's only needed when USE=web.
#
MOD_ALIAS=apache2_modules_alias
DEPEND="sys-devel/libtool
	virtual/mailx
	perl? ( dev-lang/perl:= )
	web? (
		app-arch/unzip
		media-libs/gd[jpeg,png]
		lighttpd? ( www-servers/lighttpd[php] )
		apache2? (
			|| (
				>=www-servers/apache-2.4[${MOD_ALIAS},apache2_modules_cgi]
				>=www-servers/apache-2.4[${MOD_ALIAS},apache2_modules_cgid]
				>=www-servers/apache-2.4[${MOD_ALIAS},apache2_modules_fcgid] )
			|| (
				dev-lang/php:*[apache2]
				dev-lang/php:*[cgi]
				dev-lang/php:*[fpm] )
		)
	)"
RDEPEND="${DEPEND}
	vim-syntax? ( app-vim/nagios-syntax )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-4.3.1-fix-upstream-issue-337.patch )

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
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
		# Only compile the CGIs/HTML when USE=web is set.
		emake CC=$(tc-getCC) DESTDIR="${D}" cgis html
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

	newinitd "${FILESDIR}"/nagios4-r1 nagios
	newconfd "${FILESDIR}"/conf.d nagios

	if use web ; then
		if use apache2 ; then
			# Install the Nagios configuration file for Apache.
			insinto "/etc/apache2/modules.d"
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
