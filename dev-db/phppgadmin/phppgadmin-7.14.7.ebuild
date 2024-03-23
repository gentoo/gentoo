# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

MY_P="phpPgAdmin-${PV}-mod"

DESCRIPTION="Web-based administration for Postgres database in php"
HOMEPAGE="http://phppgadmin.sourceforge.net/"
SRC_URI="https://github.com/ReimuHakurei/phpPgAdmin/archive/refs/tags/v${PV}-mod.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"

RDEPEND="dev-lang/php[postgres,session,unicode]"

S="${WORKDIR}/${MY_P}"

src_install() {
	webapp_src_preinst

	local doc
	local docs="BUGS CREDITS DEVELOPERS FAQ HISTORY INSTALL TODO TRANSLATORS"
	dodoc ${docs}
	mv conf/config.inc.php-dist conf/config.inc.php || die

	cp -r * "${D}${MY_HTDOCSDIR}"
	for doc in ${docs} INSTALL LICENSE; do
		rm -f "${D}${MY_HTDOCSDIR}/${doc}" || die
	done

	webapp_configfile "${MY_HTDOCSDIR}"/conf/config.inc.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
