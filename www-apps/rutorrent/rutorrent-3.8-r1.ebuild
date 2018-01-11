# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

DESCRIPTION="ruTorrent is a front-end for the popular Bittorrent client rTorrent"
HOMEPAGE="https://github.com/Novik/ruTorrent"
SRC_URI="https://github.com/Novik/ruTorrent/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

need_httpd_cgi

DEPEND="
	|| ( dev-lang/php[xml,gd] dev-lang/php[xml,gd-external] )
"
RDEPEND="virtual/httpd-php"

S="${WORKDIR}/ruTorrent-${PV}"

pkg_setup() {
	webapp_pkg_setup
}

src_prepare() {
	default
	find -name '\.gitignore' -type f -exec rm -rf {} \;
	# The 3.8 release of ruTorrent includes an .htaccess file that defines a .htpasswd that doesn't exist
	rm '.htaccess'
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	chmod +x "${ED}${MY_HTDOCSDIR}"/plugins/*/*.sh \
		"$ED${MY_HTDOCSDIR}"/php/test.sh || die "chmod failed"

	webapp_serverowned "${MY_HTDOCSDIR}"/share
	webapp_serverowned "${MY_HTDOCSDIR}"/share/settings
	webapp_serverowned "${MY_HTDOCSDIR}"/share/torrents
	webapp_serverowned "${MY_HTDOCSDIR}"/share/users

	webapp_configfile "${MY_HTDOCSDIR}"/conf/.htaccess
	webapp_configfile "${MY_HTDOCSDIR}"/conf/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/conf/access.ini
	webapp_configfile "${MY_HTDOCSDIR}"/conf/plugins.ini
	webapp_configfile "${MY_HTDOCSDIR}"/share/.htaccess

	webapp_src_install
}
