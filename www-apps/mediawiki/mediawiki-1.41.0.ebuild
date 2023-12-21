# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit webapp

MY_BRANCH=$(ver_cut 1-2)

DESCRIPTION="The MediaWiki wiki web application (as used on wikipedia.org)"
HOMEPAGE="http://www.mediawiki.org"
SRC_URI="http://releases.wikimedia.org/${PN}/${MY_BRANCH}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="imagemagick mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="dev-lang/php[calendar,ctype,fileinfo,iconv,intl,json(+),postgres?,session,ssl,unicode,xml,xmlreader]
	imagemagick? ( virtual/imagemagick-tools )
	!imagemagick? ( dev-lang/php[gd] )
	mysql? ( dev-lang/php[mysql,mysqli] )
	sqlite? (
		dev-db/sqlite[fts3(+)]
		dev-lang/php[pdo,sqlite]
	)
	virtual/httpd-php"

need_httpd_cgi

RESTRICT="test"

src_unpack() {
	default

	# remove lua binaries (bug #631554)
	rm -r "${S}"/extensions/Scribunto/includes/Engines/LuaStandalone/binaries || die "Failed to remove Lua binaries"
}

src_install() {
	webapp_src_preinst

	# First we install docs and then copy everything left into htdocs dir
	# to avoid bugs like #236411.

	# We ensure the directories are prepared for writing.  The post-
	# install instructions guide the user to enable the feature.
	local DOCS="FAQ HISTORY INSTALL README.md RELEASE-NOTES-${PV:0:4} UPGRADE"
	dodoc ${DOCS} docs/*.txt
	docinto databases
	dodoc docs/databases/*

	# Clean everything not used at the site...
	rm -r ${DOCS} COPYING tests docs || die
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
		elog "If you plan to use the Scribunto extension with Lua, make sure to configure"
		elog "path to Lua executable using this documentation:"
		elog "https://www.mediawiki.org/wiki/Extension:Scribunto#Lua_binary"
		echo
		ewarn "Back up existing files and the database before upgrade."
		ewarn "http://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki"
		ewarn "provides an overview of the backup process."
		echo
	fi
}
