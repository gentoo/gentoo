# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user eutils webapp vcs-snapshot

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="http://tt-rss.org/"
SRC_URI="https://dev.gentoo.org/~tomka/files/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="daemon +mysql postgres"

DEPEND="
	daemon? ( dev-lang/php:*[mysql?,postgres?,pcntl,curl] )
	!daemon? ( dev-lang/php:*[mysql?,postgres?,curl] )
	virtual/httpd-php:*
"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( mysql postgres )"

need_httpd_cgi  # From webapp.eclass

pkg_setup() {
	webapp_pkg_setup

	if use daemon; then
			enewgroup ttrssd
			enewuser ttrssd -1 /bin/sh /dev/null ttrssd
	fi
}

src_prepare() {
	# Customize config.php-dist so that the right 'DB_TYPE' is already set (according to the USE flag)
	einfo "Customizing config.php-dist..."

	if use mysql && ! use postgres; then
			sed -i \
				-e "/define('DB_TYPE',/{s:pgsql:mysql:}" \
				config.php-dist || die
	fi

	sed -i \
		-e "/define('DB_TYPE',/{s:// \(or mysql\):// pgsql \1:}" \
		config.php-dist || die

	# per 462578
	epatch_user
}

src_install() {
	webapp_src_preinst

	insinto "/${MY_HTDOCSDIR}"
	doins -r *
	keepdir "/${MY_HTDOCSDIR}"/feed-icons

	for DIR in cache lock feed-icons; do
			webapp_serverowned -R "${MY_HTDOCSDIR}/${DIR}"
	done

	# In the old days we put a config.php directly and tried to
	# protect it with the following which did not work reliably.
	# These days we only install the config.php-dist file.
	# webapp_configfile "${MY_HTDOCSDIR}"/config.php

	if use daemon; then
			webapp_postinst_txt en "${FILESDIR}"/postinstall-en-with-daemon.txt
			newinitd "${FILESDIR}"/ttrssd.initd-r2 ttrssd
			newconfd "${FILESDIR}"/ttrssd.confd-r1 ttrssd
			insinto /etc/logrotate.d/
			newins "${FILESDIR}"/ttrssd.logrotated ttrssd

			elog "After upgrading, please restart ttrssd"
	else
			webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	fi

	webapp_src_install
}

pkg_postinst() {
	elog "You need to merge config.php and config.php-dist manually now."
	webapp_pkg_postinst
}
