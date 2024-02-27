# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp optfeature

DESCRIPTION="ruTorrent is a front-end for the popular Bittorrent client rTorrent"
HOMEPAGE="https://github.com/Novik/ruTorrent"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Novik/ruTorrent.git"
else
	SRC_URI="https://github.com/Novik/ruTorrent/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
	S="${WORKDIR}/ruTorrent-${PV}"
fi

LICENSE="GPL-2+ MIT"

RDEPEND="
	dev-lang/php[xml,gd]
	virtual/httpd-php
"

need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	rm -r .github || die
	find . \( -name .gitignore -o -name .gitmodules \) -type f -delete || die
	if [[ ${PV} == 9999 ]]; then
		rm -r .git .gitattributes || die
	fi

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	# can not use fperms beacuse of globbing
	chmod +x "${ED}${MY_HTDOCSDIR}"/plugins/*/*.sh \
		"${ED}${MY_HTDOCSDIR}"/php/test.sh || die "chmod failed"

	keepdir "${MY_HTDOCSDIR}"/conf/users
	keepdir "${MY_HTDOCSDIR}"/share/settings
	keepdir "${MY_HTDOCSDIR}"/share/torrents
	keepdir "${MY_HTDOCSDIR}"/share/users

	webapp_serverowned -R "${MY_HTDOCSDIR}"/conf
	webapp_serverowned -R "${MY_HTDOCSDIR}"/share

	webapp_configfile "${MY_HTDOCSDIR}"/conf/.htaccess
	webapp_configfile "${MY_HTDOCSDIR}"/conf/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/conf/access.ini
	webapp_configfile "${MY_HTDOCSDIR}"/conf/plugins.ini
	webapp_configfile "${MY_HTDOCSDIR}"/share/.htaccess

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	optfeature "Show audio file spectogram" media-sound/sox
	optfeature "Display media file information" media-video/mediainfo
	optfeature "Scrape Cloudflare based sites" dev-python/cloudscraper
}
