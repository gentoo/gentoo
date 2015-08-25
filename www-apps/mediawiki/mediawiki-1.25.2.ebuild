# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit webapp versionator

MY_BRANCH=$(get_version_component_range 1-2)

DESCRIPTION="The MediaWiki wiki web application (as used on wikipedia.org)"
HOMEPAGE="http://www.mediawiki.org"
SRC_URI="http://releases.wikimedia.org/${PN}/${MY_BRANCH}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc x86"
IUSE="imagemagick mysql postgres sqlite"

RDEPEND=">=dev-lang/php-5.3.2[json,mysql?,postgres?,session,xml,xmlreader]
	imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
	!imagemagick? ( dev-lang/php[gd] )
	sqlite? (
		dev-db/sqlite:3[fts3(+)]
		>=dev-lang/php-5.3.2[pdo]
		|| ( dev-lang/php[sqlite] dev-lang/php[sqlite3] )
	)
	virtual/httpd-php"

need_httpd_cgi

RESTRICT="test"

src_install() {
	webapp_src_preinst

	# First we install docs and then copy everything left into htdocs dir
	# to avoid bugs like #236411.

	# We ensure the directories are prepared for writing.  The post-
	# install instructions guide the user to enable the feature.
	local DOCS="FAQ HISTORY INSTALL README RELEASE-NOTES-${PV:0:4} UPGRADE"
	dodoc ${DOCS} docs/*.txt
	docinto php-memcached
	dodoc docs/php-memcached/*

	# Clean everything not used at the site...
	rm -rf ${DOCS} COPYING tests docs || die
	find . -name Makefile -delete || die
	# and install
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	# If imagemagick is enabled then setup for image upload.
	# We ensure the directory is prepared for writing.
	if use imagemagick ; then
		webapp_serverowned "${MY_HTDOCSDIR}"/images
	fi

	webapp_postinst_txt en "${FILESDIR}/postinstall-1.18-en.txt"
	webapp_postupgrade_txt en "${FILESDIR}/postupgrade-1.16-en.txt"
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		echo
		elog "=== Consult the release notes ==="
		elog "Before doing anything, stop and consult the release notes"
		elog "/usr/share/doc/${PF}/RELEASE-NOTES-${PV:0:4}.bz2"
		echo
		elog "These detail bug fixes, new features and functionality, and any"
		elog "particular points that may need to be noted during the upgrade procedure."
		echo
		ewarn "Back up existing files and the database before upgrade."
		ewarn "http://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki"
		ewarn "provides an overview of the backup process."
		echo
	fi
}
