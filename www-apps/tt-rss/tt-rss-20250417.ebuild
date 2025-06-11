# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

if [[ ${PV} == *9999999* ]]; then
	SLOT="${PV}" # Single live slot.
	EGIT_REPO_URI="https://git.tt-rss.org/fox/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~chewi/distfiles/${P}.tar.xz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="https://tt-rss.org/"
LICENSE="GPL-3"
IUSE="+acl daemon gd +mysqli postgres"
REQUIRED_USE="|| ( mysqli postgres )"

PHP_SLOTS="8.3 8.2" # Check with: grep PHP_VERSION classes/Config.php
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
	"${FILESDIR}"/${PN}-no-chmod.patch
)

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

	if use mysqli; then
		elog
		elog "You are currently using tt-rss with the mysql backend."
		elog
		elog "THIS IS NOT SUPPORTED BEYOND THIS VERSION."
		elog
		elog "Since 2025-04-17, tt-rss has dropped support for MySQL."
		elog
		elog "To upgrade, you need to migrate to PostgreSQL using this version first."
		elog
		elog "Export/Import articles could be done with an official plugin:"
		elog "ttrss-data-migration"
		elog "For plugin installation and export/import, see:"
		elog "https://gitlab.tt-rss.org/tt-rss/plugins/ttrss-data-migration"
		elog
		elog "Example of migration steps:"
		elog "0. Setup PostgreSQL (dev-db/postgresql)"
		elog "1. Backup !"
		elog "2. Export settings/feeds (OPML)"
		elog "3. Export articles (JSON) via ttrss-data-migration"
		elog "4. Migrate to PostgreSQL backend changing USE flag mysqli to postgres"
		elog "5. Emerge www-apps/tt-rss with new USE flag"
		elog "6. Setup fresh install of tt-rss with PostgreSQL backend"
		elog "7. Import settings/feeds (OPML)"
		elog "8. Import articles"
		elog
	fi
}
