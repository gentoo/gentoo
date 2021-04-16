# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit webapp

DESCRIPTION="Web-based solution for managing scientific literature, references and citations"
HOMEPAGE="http://www.refbase.net/"
SRC_URI="https://sourceforge.net/code-snapshots/svn/r/re/refbase/code/refbase-code-r1422-branches-bleeding-edge.zip -> ${P}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=dev-lang/php-5.3[mysql,mysqli(+),session]
	virtual/httpd-php
	app-admin/webapp-config
	app-text/bibutils"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}-code-r1422-branches-bleeding-edge"

src_install() {
	webapp_src_preinst

	DOCS="AUTHORS BUGS ChangeLog NEWS README TODO UPDATE"
	einstalldocs
	# Don't install docs to webroot
	rm -f ${DOCS} COPYING INSTALL

	cp -R * "${D}"${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/initialize
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
