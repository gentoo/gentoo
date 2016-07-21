# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit depend.apache eutils multilib toolchain-funcs user

MY_P=${PN/-core}-${PV}
DESCRIPTION="Nagios Core - Check daemon, CGIs, docs"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ppc ppc64 sparc x86"
IUSE="debug lighttpd perl +web vim-syntax"
DEPEND="virtual/mailx
	web? (
		>=media-libs/gd-1.8.3-r5[jpeg,png]
		lighttpd? ( www-servers/lighttpd dev-lang/php[cgi] )
		apache2? ( || ( dev-lang/php[apache2] dev-lang/php[cgi] ) )
	)
	perl? ( >=dev-lang/perl-5.6.1-r7 )"
RDEPEND="${DEPEND}
	!net-analyzer/nagios-imagepack
	vim-syntax? ( app-vim/nagios-syntax )"

want_apache2

S="${WORKDIR}/${PN/-core}"

pkg_setup() {
	depend.apache_pkg_setup

	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.5.1-process_cgivars.patch"
	local strip="$(echo '$(MAKE) strip-post-install')"
	sed -i -e "s:${strip}::" {cgi,base}/Makefile.in || die "sed failed in Makefile.in"
}

src_configure() {
	local myconf

	if use perl ; then
		myconf="${myconf} --enable-embedded-perl --with-perlcache"
	fi

	if use debug; then
		myconf="${myconf} --enable-DEBUG0"
		myconf="${myconf} --enable-DEBUG1"
		myconf="${myconf} --enable-DEBUG2"
		myconf="${myconf} --enable-DEBUG3"
		myconf="${myconf} --enable-DEBUG4"
		myconf="${myconf} --enable-DEBUG5"
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

	if use web ; then
		# Only compile the CGI's if "web" useflag is set.
		emake CC=$(tc-getCC) DESTDIR="${D}" cgis
	fi
}

src_install() {
	dodoc Changelog INSTALLING LEGAL README UPGRADING

	if ! use web ; then
		sed -i -e 's/cd $(SRC_CGI) && $(MAKE) $@/# line removed due missing web use flag/' \
			-e 's/cd $(SRC_HTM) && $(MAKE) $@/# line removed due missing web use flag/' \
			-e 's/$(MAKE) install-exfoliation/# line removed due missing web use flag/' \
			Makefile
	fi

	sed -i -e 's/^contactgroups$//g' Makefile

	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" install-config
	emake DESTDIR="${D}" install-commandmode
	if use web; then
		emake DESTDIR="${D}" install-classicui
	fi

	newinitd "${FILESDIR}"/nagios3 nagios
	newconfd "${FILESDIR}"/conf.d nagios

	# Apache Module
	if use web ; then
		if use apache2 ; then
			insinto "${APACHE_MODULES_CONFDIR}"
			doins "${FILESDIR}"/99_nagios3.conf
	    elif use lighttpd ; then
			insinto /etc/lighttpd
			newins "${FILESDIR}/lighttpd_nagios3-r1.conf" nagios.conf
		else
			ewarn "${CATEGORY}/${PF} only supports Apache-2.x or Lighttpd webserver"
			ewarn "out-of-the-box. Since you are not using one of them, you"
			ewarn "have to configure your webserver accordingly yourself."
		fi

	fi

	for dir in etc/nagios var/nagios ; do
		chown -R nagios:nagios "${D}/${dir}" || die "Failed chown of ${D}/${dir}"
	done

	dosbin p1.pl

	chown -R root:root "${D}"/usr/$(get_libdir)/nagios
	find "${D}"/usr/$(get_libdir)/nagios -type d -print0 | xargs -0 chmod 755
	find "${D}"/usr/$(get_libdir)/nagios/cgi-bin -type f -print0 | xargs -0 chmod 755

	keepdir /etc/nagios
	keepdir /var/nagios
	keepdir /var/nagios/archives
	keepdir /var/nagios/rw
	keepdir /var/nagios/spool/checkresults

	if use !apache2 && use !lighttpd; then
		chown -R nagios:nagios "${D}"/var/nagios/rw || die "Failed chown of ${D}/var/nagios/rw"
	else
		if use apache2 ; then
			chown -R nagios:apache "${D}"/var/nagios/rw || die "Failed chown of ${D}/var/nagios/rw"
		elif use lighttpd ; then
			chown -R nagios:lighttpd "${D}"/var/nagios/rw || die "Failed chown of ${D}/var/nagios/rw"
		fi
	fi

	chmod ug+s "${D}"/var/nagios/rw || die "Failed Chmod of ${D}/var/nagios/rw"
	chmod 0750 "${D}"/etc/nagios || die "Failed chmod of ${D}/etc/nagios"
}

pkg_postinst() {
	elog "If you want nagios to start at boot time"
	elog "remember to execute:"
	elog "  rc-update add nagios default"
	elog

	if use web ; then
		elog "This does not include cgis that are perl-dependent"
		elog "Currently traceroute.cgi is perl-dependent"
		elog "To have ministatus.cgi requires copying of ministatus.c"
		elog "to cgi directory for compiling."

		elog "Note that the user your webserver is running at needs"
		elog "read-access to /etc/nagios."
		elog

		if use apache2 || use lighttpd ; then
			elog "There are several possible solutions to accomplish this,"
			elog "choose the one you are most comfortable with:"
			elog
			if use apache2 ; then
				elog "	usermod -G nagios apache"
				elog "or"
				elog "	chown nagios:apache /etc/nagios"
				elog
				elog "Also edit /etc/conf.d/apache2 and add \"-D NAGIOS\""
			elif use lighttpd ; then
				elog "  usermod -G nagios lighttpd "
				elog "or"
				elog "  chown nagios:lighttpd /etc/nagios"
			fi
			elog
			elog "That will make nagios's web front end visable via"
			elog "http://localhost/nagios/"
			elog
		else
			elog "IMPORTANT: Do not forget to add the user your webserver"
			elog "is running as to the nagios group!"
		fi

	else
		elog "Please note that you have installed Nagios without web interface."
		elog "Please don't file any bugs about having no web interface when you do this."
		elog "Thank you!"
	fi

	elog
	elog "If your kernel has /proc protection, nagios"
	elog "will not be happy as it relies on accessing the proc"
	elog "filesystem. You can fix this by adding nagios into"
	elog "the group wheel, but this is not recomended."
	elog
}

pkg_postinst() {
	einfo "Fixing permissions"
	chown nagios:nagios "${ROOT}"var/nagios
}
