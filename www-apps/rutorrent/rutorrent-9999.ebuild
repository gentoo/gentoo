# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="ruTorrent is a front-end for the popular Bittorrent client rTorrent"
HOMEPAGE="https://github.com/Novik/ruTorrent"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Novik/ruTorrent.git"
else
	SRC_URI="https://github.com/Novik/ruTorrent/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"

RDEPEND="
	${DEPEND}
	dev-lang/php[xml,gd]
	virtual/httpd-php
"

need_httpd_cgi

src_prepare() {
	default
	find ${S} -name '.gitignore' -type f | xargs rm -f || die
	if [[ ${PV} == 9999 ]]; then
		find ${S}  -name '.git' -type d | xargs rm -rf || die
		rm -rf .github || die
	fi
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	
	webapp_serverowned "${MY_HTDOCSDIR}"/share
	webapp_serverowned "${MY_HTDOCSDIR}"/share/settings
	webapp_serverowned "${MY_HTDOCSDIR}"/share/torrents
	webapp_serverowned "${MY_HTDOCSDIR}"/share/users

	webapp_configfile "${MY_HTDOCSDIR}"/conf/.htaccess
	webapp_configfile "${MY_HTDOCSDIR}"/conf/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/conf/access.ini
	webapp_configfile "${MY_HTDOCSDIR}"/conf/plugins.ini
	webapp_configfile "${MY_HTDOCSDIR}"/share/.htaccess

	for i in "${MY_HTDOCSDIR}"/plugins/*/*.sh "${MY_HTDOCSDIR}"/php/test.sh ; do
		fperms +x ${i} || die
	done

	webapp_src_install
}
