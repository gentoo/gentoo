# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit webapp

DESCRIPTION="multilanguage CalDAV web client"
HOMEPAGE="http://agendav.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~ppc64"

RDEPEND=">=dev-lang/php-5.6[ctype,curl,unicode,tokenizer,xml,xmlreader,xmlwriter]
	virtual/httpd-php
	|| ( >=virtual/mysql-5.1 >=dev-db/postgresql-8.1 )"

src_install() {
	webapp_src_preinst

	einfo "Installing web files"
	# fix references to the rest of the application code
	sed -i -e '/__DIR__/s:/\.\./:/../../agendav/:' web/public/index.php || die
	insinto "${MY_HTDOCSDIR}"
	doins -r web/public/*

	einfo "Installing main files"
	cp web/config/{default.,}settings.php || die
	insinto "${MY_HOSTROOTDIR}/${PN}"
	doins -r web/{app,config,lang,src,templates,var,vendor}

	einfo "Installing agendavcli utility"
	sed -i -e '/__DIR__/s:/web/:/:' agendavcli || die
	sed -i -e '/migrations_directory/s:web/::' migrations.yml || die
	doins migrations.yml
	exeinto "${MY_HOSTROOTDIR}/${PN}"
	doexe agendavcli

	local f
	for f in "${ED}"/${MY_HOSTROOTDIR}/${PN}/config/* ; do
		webapp_configfile "${f#${ED%/}}"
	done
	webapp_serverowned -R "${MY_HOSTROOTDIR}"/${PN}/var

	webapp_postinst_txt en "${FILESDIR}/postinstall-2.2.0-en.txt"
	webapp_src_install
}
