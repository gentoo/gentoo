# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs user

MY_P=${PN/-core}-${PV}
DESCRIPTION="Nagios core - monitoring daemon, web GUI, and documentation"
HOMEPAGE="https://www.nagios.org/"

# The name of the directory into which our Gentoo icons will be
# extracted, and also the basename of the archive containing it.
GENTOO_ICONS="${PN}-gentoo-icons-20141125"
SRC_URI="mirror://sourceforge/nagios/${MY_P}.tar.gz
	web? ( https://dev.gentoo.org/~mjo/distfiles/${GENTOO_ICONS}.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
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
DEPEND="dev-libs/libltdl:0
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

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 -1 -1 nagios
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
		--localstatedir=/var/lib/nagios \
		--sysconfdir=/etc/nagios \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--with-cgibindir=/usr/$(get_libdir)/nagios/cgi-bin \
		--with-webdir=/usr/share/nagios/htdocs
}

src_compile() {
	emake CC=$(tc-getCC) nagios

	if use web; then
		# Only compile the CGIs/HTML when USE=web is set.
		emake CC=$(tc-getCC) DESTDIR="${D}" cgis html
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

	newinitd startup/openrc-init nagios

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
}

pkg_postinst() {

	if use web; then
		if use apache2 || use lighttpd ; then
			if use apache2; then
				elog "To enable the Nagios web front-end, please edit"
				elog "${ROOT}etc/conf.d/apache2 and add \"-D NAGIOS -D PHP\""
				elog "to APACHE2_OPTS. Then Nagios will be available at,"
				elog
			elif use lighttpd; then
				elog "To enable the Nagios web front-end, please add"
				elog "'include \"nagios.conf\"' to the lighttpd configuration"
				elog "file at ${ROOT}etc/lighttpd/lighttpd.conf. Then Nagios"
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
		ewarn "from ${EROOT}var/nagios to ${EROOT}var/lib/nagios. If you"
		ewarn "wish to migrate your state to the new location, first stop"
		ewarn "nagios and then run"
		ewarn ""
		ewarn "  diff --recursive --brief ${EROOT}var/nagios ${EROOT}var/lib/nagios"
		ewarn ""
		ewarn "to identify any files that should be moved to the new"
		ewarn "location. They can simply be moved with \"mv\" before"
		ewarn "restarting nagios."
	fi
}
