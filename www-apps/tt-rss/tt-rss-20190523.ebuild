# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix user webapp

COMMIT="4a2836ea90c4c471029d189a8c9fe5ec10a9521b"
DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="https://tt-rss.org/"
SRC_URI="https://git.tt-rss.org/git/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE="+acl daemon +mysqli postgres"
REQUIRED_USE="|| ( mysqli postgres )"

DEPEND="daemon? ( acl? ( sys-apps/acl ) )"

RDEPEND="${DEPEND}
	daemon? ( dev-lang/php:*[mysqli?,postgres?,curl,cli,intl,pcntl,pdo] )
	!daemon? ( dev-lang/php:*[mysqli?,postgres?,curl,intl,pdo] )
	virtual/httpd-php:*"

DEPEND="!vhosts? ( ${DEPEND} )"

need_httpd_cgi # From webapp.eclass

S="${WORKDIR}/${PN}"

pkg_setup() {
	webapp_pkg_setup

	if use daemon; then
		enewgroup ttrssd
		enewuser ttrssd -1 /bin/sh /dev/null ttrssd
	fi
}

src_configure() {
	hprefixify config.php-dist

	sed -i -r \
		-e "/'DB_TYPE'/s:,.*:, '$(usex mysqli mysql pgsql)'); // mysql or pgsql:" \
		-e "/'CHECK_FOR_UPDATES'/s/true/false/" \
		config.php-dist || die
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	# When updating, grep the plugins directory for additional CACHE_DIR
	# instances as they cannot be created later due to permissions.
	dodir "${MY_HTDOCSDIR}"/cache/starred-images

	local dir
	for dir in "${ED}${MY_HTDOCSDIR}"/{cache/*,feed-icons,lock}/; do
		webapp_serverowned "${dir#${ED}}"
	done

	if use daemon; then
		webapp_hook_script "${FILESDIR}"/permissions
		webapp_postinst_txt en "${FILESDIR}"/postinstall-en-with-daemon-r1.txt

		newinitd "${FILESDIR}"/ttrssd.initd-r3 ttrssd
		newconfd "${FILESDIR}"/ttrssd.confd-r2 ttrssd

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/ttrssd.logrotated-r1 ttrssd

		elog "After upgrading, please restart ttrssd."
	else
		webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	fi

	webapp_src_install
}

pkg_postinst() {
	elog "You need to merge config.php-dist into config.php manually when upgrading."
	webapp_pkg_postinst
}
