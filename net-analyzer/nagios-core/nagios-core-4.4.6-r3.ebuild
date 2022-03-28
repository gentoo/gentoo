# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

MY_P="${PN/-core}-${PV}"
DESCRIPTION="Nagios core - monitoring daemon, web GUI, and documentation"
HOMEPAGE="https://www.nagios.org/"

# The name of the directory into which our Gentoo icons will be
# extracted, and also the basename of the archive containing it.
GENTOO_ICONS="${PN}-gentoo-icons-20141125"
SRC_URI="mirror://sourceforge/nagios/${MY_P}.tar.gz
	web? ( https://dev.gentoo.org/~mjo/distfiles/${GENTOO_ICONS}.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc ppc64 sparc ~x86"
IUSE="apache2 classicui lighttpd +web vim-syntax"

# In pkg_postinst(), we change the group of the Nagios configuration
# directory to that of the web server user. It can't belong to both
# apache/lighttpd groups at the same time, so we block this combination
# for our own sanity.
#
# This could be made to work, but we would need a better way to allow
# the web user read-only access to Nagios's configuration directory.
#
REQUIRED_USE="apache2? ( !lighttpd )"

#
# Note, we require one of the apache2 CGI modules:
#
#   * mod_cgi (USE=apache2_modules_cgi)
#   * mod_cgid (USE=apache2_modules_cgid)
#   * mod_fcgid (www-apache/mod_fcgid)
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

# The dependencies checked by the configure script. All of these are
# also runtime dependencies; that's why ./configure checks for them.
CONFIGURE_DEPEND="acct-group/nagios
	acct-user/nagios
	virtual/mailx
	dev-lang/perl:="

# In addition to the things that the ./configure script checks for,
# we also need to be able to unzip stuff on the build host.
#
# We need the apache/lighttpd groups in src_install() for the things
# installed as the --with-command-group argument, so they go here too.
# The groups are also needed at runtime, but that is ensured by apache
# and lighttpd themselves being in RDEPEND.
BDEPEND="${CONFIGURE_DEPEND}
	apache2? ( acct-group/apache )
	lighttpd? ( acct-group/lighttpd )
	web? ( app-arch/unzip )"

# This is linked into /usr/bin/nagios{,tats}
DEPEND="dev-libs/libltdl:0"

RDEPEND="${CONFIGURE_DEPEND}
	${DEPEND}
	web? (
		media-libs/gd[jpeg,png]
		lighttpd? ( www-servers/lighttpd[php] )
		apache2? (
			|| (
				www-servers/apache[${MOD_ALIAS},apache2_modules_cgi]
				www-servers/apache[${MOD_ALIAS},apache2_modules_cgid]
				( www-servers/apache[${MOD_ALIAS}] www-apache/mod_fcgid ) )
			|| (
				dev-lang/php:*[apache2]
				dev-lang/php:*[cgi]
				dev-lang/php:*[fpm] )
		)
	)
	vim-syntax? ( app-vim/nagios-syntax )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf

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

	# We pass "unknown" as the init type because we don't want it to
	# guess. Later on, we'll manually install both OpenRC and systemd
	# services.
	econf ${myconf} \
		--prefix="${EPREFIX}/usr" \
		--bindir="${EPREFIX}/usr/sbin" \
		--localstatedir="${EPREFIX}/var/lib/nagios" \
		--sysconfdir="${EPREFIX}/etc/nagios" \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)/nagios/plugins" \
		--with-cgibindir="${EPREFIX}/usr/$(get_libdir)/nagios/cgi-bin" \
		--with-webdir="${EPREFIX}/usr/share/nagios/htdocs" \
		--with-init-type="unknown"

	# The paths in the web server configuration files need to match
	# those passed to econf above.
	cp "${FILESDIR}/99_nagios4-r1.conf" \
		"${FILESDIR}/lighttpd_nagios4-r1.conf" \
		"${T}/" || die "failed to create copies of web server conf files"

	sed -e "s|@CGIBINDIR@|${EPREFIX}/usr/$(get_libdir)/nagios/cgi-bin|g" \
		-e "s|@WEBDIR@|${EPREFIX}/usr/share/nagios/htdocs|" \
		-i "${T}/99_nagios4-r1.conf" \
		-i "${T}/lighttpd_nagios4-r1.conf" \
		|| die "failed to substitute paths into web server conf files"

}

src_compile() {
	emake CC="$(tc-getCC)" nagios

	if use web; then
		# Only compile the CGIs/HTML when USE=web is set.
		emake CC="$(tc-getCC)" cgis html
	fi
}

src_install() {
	dodoc Changelog CONTRIBUTING.md README.md THANKS UPGRADING

	# There is no way to install the CGIs unstripped from the top-level
	# makefile, so descend into base/ here. The empty INSTALL_OPTS
	# ensures that root:root: owns the nagios executables.
	cd "${S}/base" || die
	emake INSTALL_OPTS="" DESTDIR="${D}" install-unstripped
	cd "${S}" || die

	# Otherwise this gets installed as 770 and you get "access denied"
	# for some reason or other when starting nagios. The permissions
	# on nagiostats are just for consistency (these should both get
	# fixed upstream).
	fperms 775 /usr/sbin/nagios /usr/sbin/nagiostats

	# INSTALL_OPTS are needed for most of install-basic, but we don't
	# want them on the LIBEXECDIR, argh.
	emake DESTDIR="${D}" install-basic
	fowners root:root /usr/$(get_libdir)/nagios/plugins

	# Don't make the configuration owned by the nagios user, because
	# then he can edit nagios.cfg and trick nagios into running as root
	# and doing his bidding.
	emake INSTALL_OPTS="" DESTDIR="${D}" install-config

	# No INSTALL_OPTS used in install-commandmode, thankfully.
	emake DESTDIR="${D}" install-commandmode

	# The build system installs these directories, but portage assumes
	# that the build system doesn't know what it's doing so we have to
	# keepdir them, too. I guess you'll have to manually re-check the
	# upstream build system forever to see if this is still necessary.
	keepdir /var/lib/nagios{,/archives,/rw,/spool,/spool/checkresults}

	if use web; then
		# There is no way to install the CGIs unstripped from the
		# top-level makefile, so descend into cgi/ here. The empty
		# INSTALL_OPTS ensures that root:root: owns the CGI executables.
		cd "${S}/cgi" || die
		emake INSTALL_OPTS="" DESTDIR="${D}" install-unstripped
		cd "${S}" || die

		# install-html installs the new exfoliation theme
		emake INSTALL_OPTS="" DESTDIR="${D}" install-html

		if use classicui; then
			# This overwrites the already-installed exfoliation theme
			emake INSTALL_OPTS="" DESTDIR="${D}" install-classicui
		fi

		# Install cute Gentoo icons (bug #388323), setting their
		# owner, group, and mode to match those of the rest of Nagios's
		# images.
		insinto /usr/share/nagios/htdocs/images/logos
		doins "${WORKDIR}/${GENTOO_ICONS}"/*.*
	fi

	# The ./configure script for nagios detects the init system on the
	# build host, which is wrong for all sorts of reasons. We've gone
	# to great lengths above to avoid running "install-init" -- even
	# indirectly -- and so now we must install whatever service files
	# we need by hand.
	newinitd startup/openrc-init nagios
	systemd_newunit startup/default-service nagios.service

	if use web ; then
		if use apache2 ; then
			# Install the Nagios configuration file for Apache.
			insinto "/etc/apache2/modules.d"
			newins "${T}/99_nagios4-r1.conf" "99_nagios4.conf"
		elif use lighttpd ; then
			# Install the Nagios configuration file for Lighttpd.
			insinto /etc/lighttpd
			newins "${T}/lighttpd_nagios4-r1.conf" nagios.conf
		else
			ewarn "${CATEGORY}/${PF} only supports apache or lighttpd"
			ewarn "out of the box. Since you are not using one of them, you"
			ewarn "will have to configure your webserver yourself."
		fi
	fi
}

pkg_postinst() {

	if use web; then
		if use apache2 || use lighttpd ; then
			if use apache2; then
				elog "To enable the Nagios web front-end, please edit"
				elog "${ROOT}/etc/conf.d/apache2 and add \"-D NAGIOS -D PHP\""
				elog "to APACHE2_OPTS. Then Nagios will be available at,"
				elog
			elif use lighttpd; then
				elog "To enable the Nagios web front-end, please add"
				elog "'include \"nagios.conf\"' to the lighttpd configuration"
				elog "file at ${ROOT}/etc/lighttpd/lighttpd.conf. Then Nagios"
				elog "will be available at,"
				elog
			fi

			elog "  http://localhost/nagios/"
		fi
	fi

	elog
	elog "If your kernel has /proc protection, nagios"
	elog "will not be happy as it relies on accessing the proc"
	elog "filesystem. You can fix this by adding nagios into"
	elog "the group wheel, but this is not recomended."
	elog

	if [ -n "${REPLACING_VERSIONS}" ]; then
		ewarn "The local state directory for nagios has changed in v4.4.5,"
		ewarn "from ${EROOT}/var/nagios to ${EROOT}/var/lib/nagios. If you"
		ewarn "wish to migrate your state to the new location, first stop"
		ewarn "nagios and then run"
		ewarn ""
		ewarn "  diff --recursive --brief ${EROOT}/var/nagios ${EROOT}/var/lib/nagios"
		ewarn ""
		ewarn "to identify any files that should be moved to the new"
		ewarn "location. They can simply be moved with \"mv\" before"
		ewarn "restarting nagios."
	fi
}
