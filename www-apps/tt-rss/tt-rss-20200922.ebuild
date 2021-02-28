# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix webapp

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="https://tt-rss.org/"
SRC_URI="https://dev.gentoo.org/~chewi/distfiles/${P}.tar.gz" # Upstream git frontend blocks wget?
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE="+acl daemon gd +mysqli postgres"
REQUIRED_USE="|| ( mysqli postgres )"

PHP_SLOTS="7.4 7.3 7.2"
PHP_USE="gd?,mysqli?,postgres?,curl,fileinfo,intl,json(+),pdo,unicode,xml"

php_rdepend() {
	local slot
	echo "|| ("
	for slot in ${PHP_SLOTS}; do
		echo "(
			virtual/httpd-php:${slot}
			dev-lang/php:${slot}[$1]
		)"
	done
	echo ")"
}

DEPEND="
	daemon? ( acl? ( sys-apps/acl ) )
"

RDEPEND="
	${DEPEND}
	daemon? (
		acct-user/ttrssd
		acct-group/ttrssd
		$(php_rdepend "${PHP_USE},cli,pcntl")
	)
	!daemon? (
		$(php_rdepend "${PHP_USE}")
	)
"

DEPEND="
	!vhosts? ( ${DEPEND} )
"

need_httpd_cgi # From webapp.eclass

S="${WORKDIR}/${PN}"

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
