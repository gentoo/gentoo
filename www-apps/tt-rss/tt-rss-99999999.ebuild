# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 webapp

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="https://tt-rss.org/"
EGIT_REPO_URI="https://git.tt-rss.org/fox/${PN}.git"
LICENSE="GPL-3"
SLOT="${PV}" # Single live slot.
IUSE="+acl daemon gd +mysqli postgres"
REQUIRED_USE="|| ( mysqli postgres )"

PHP_SLOTS="8.1 8.0 7.4"
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

PATCHES=(
	"${FILESDIR}"/${PN}-no-chmod-r2.patch
)

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
		webapp_hook_script "${FILESDIR}"/permissions-r1
		webapp_postinst_txt en "${FILESDIR}"/postinstall-en-with-daemon-r1.txt

		newinitd "${FILESDIR}"/ttrssd.initd-r4 ttrssd
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
	if use vhosts && [[ -n ${REPLACING_VERSIONS} ]]; then
		elog
		elog "The live ebuild does not automatically upgrade your installations so"
		elog "don't forget to do so manually."
	fi

	webapp_pkg_postinst
}
