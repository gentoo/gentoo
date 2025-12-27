# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

if [[ ${PV} == *9999999* ]]; then
	SLOT="${PV}" # Single live slot.
	EGIT_REPO_URI="https://github.com/tt-rss/${PN}.git"
	inherit git-r3
else
	COMMIT=""
	SRC_URI="https://github.com/tt-rss/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="https://github.com/tt-rss/"
LICENSE="GPL-3"
IUSE="+acl daemon gd"

PHP_SLOTS="8.5 8.4 8.3 8.2" # min_ver: PHP_VERSION classes/Config.php / current_ver: PHP_SUFFIX .docker/app/Dockerfile
PHP_USE="gd?,postgres,ctype,curl,fileinfo,filter,intl,pdo,tokenizer,unicode,xml"

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

pkg_pretend() {
	if has_version www-apps/tt-rss[mysqli]; then
		ewarn
		ewarn "You are currently using tt-rss with the mysql backend."
		ewarn
		ewarn "THIS IS NOT SUPPORTED ANYMORE."
		ewarn
		ewarn "Since 2025-04-17, tt-rss has dropped support for MySQL."
		ewarn
		ewarn "To upgrade, you need to migrate to PostgreSQL first."
		ewarn
		ewarn "Migrating between different tt-rss versions might work but is not recommended."
		ewarn "It's recommended to switch to =www-apps/tt-rss-20250417 for migration."
		ewarn
		ewarn "Export/Import articles could be done with an official plugin:"
		ewarn "ttrss-data-migration"
		ewarn "For plugin installation and export/import, see:"
		ewarn "https://github.com/tt-rss/tt-rss-plugin-data-migration"
		ewarn
		ewarn "Example of migration steps:"
		ewarn "0. Setup PostgreSQL (dev-db/postgresql)"
		ewarn "1. Backup !"
		ewarn "2. Export settings/feeds (OPML)"
		ewarn "3. Export articles (JSON) via ttrss-data-migration"
		ewarn "4. Migrate to PostgreSQL backend changing USE flag mysqli to postgres"
		ewarn "5. Emerge www-apps/tt-rss with new USE flag"
		ewarn "6. Setup fresh install of tt-rss with PostgreSQL backend"
		ewarn "7. Import settings/feeds (OPML)"
		ewarn "8. Import articles"
		ewarn
		die "MySQL backend not supported anymore"
	fi
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	# When updating, grep the code for new DiskCache::instance occurrences as
	# these directories cannot be created later due to permissions. Some
	# of these directories are already present in the source tree.
	keepdir "${MY_HTDOCSDIR}"/cache/{feed-icons,starred-images}

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
	if ! use vhosts && [[ -n ${REPLACING_VERSIONS} && ${PV} == *9999999* ]]; then
		elog
		elog "The live ebuild does not automatically upgrade your installations so"
		elog "don't forget to do so manually."
	fi

	webapp_pkg_postinst
}
