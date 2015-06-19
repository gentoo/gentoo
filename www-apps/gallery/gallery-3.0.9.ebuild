# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/gallery/gallery-3.0.9.ebuild,v 1.7 2014/04/15 14:03:19 blueness Exp $

EAPI="5"

inherit webapp

DESCRIPTION="Web based (PHP Script) photo album viewer/creator"
HOMEPAGE="http://gallery.menalto.com/"
SRC_URI="mirror://sourceforge/gallery/${PN}/${P}.zip"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="ffmpeg +gd imagemagick mysql mysqli"

# Build depend is on unzip
DEPEND="app-arch/unzip"

#PHP flags
PHP_REQUIRED_FLAGS="ctype,filter,iconv,json,simplexml,tokenizer,unicode"
PHP_OPTIONAL_FLAGS="gd?,mysql?,mysqli?"

# No forced dependency on
#  mysql? ( virtual/mysql )
# which may live on another server
RDEPEND="
	imagemagick? ( || (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
	) )
	ffmpeg? ( virtual/ffmpeg )
	>=dev-lang/php-5.2.3[${PHP_REQUIRED_FLAGS},${PHP_OPTIONAL_FLAGS}]
	virtual/httpd-php"

REQUIRED_USE="
	|| ( gd imagemagick )
	|| ( mysql mysqli )"

S="${WORKDIR}/${PN}3"

src_install() {
	webapp_src_preinst

	rm LICENSE
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	keepdir "${MY_HTDOCSDIR}"/var
	webapp_serverowned "${MY_HTDOCSDIR}"/var

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en "${FILESDIR}"/postupgrade-en.txt

	webapp_src_install
}

pkg_postinst() {
	ewarn
	ewarn "\033[1;33m**************************************************\033[00m"
	ewarn
	ewarn "gallery3 requires short_open_tag to be enabled."
	ewarn "You need to edit \"/etc/php/apache2-php5.?/php.ini\","
	ewarn "set short_open_tag to \"On\" and then restart apache."
	ewarn
	ewarn "This ebuild does not depend on mysql or mariadb,"
	ewarn "because the database may run on different host.  But"
	ewarn "you will need to run a database server somewhere."
	ewarn
	ewarn "\033[1;33m**************************************************\033[00m"
	ewarn

	einfo
	einfo "\033[1;32m**************************************************\033[00m"
	einfo
	einfo "To see the post install instructions, do"
	einfo
	einfo "    webapp-config --show-postinst ${PN} ${PVR}"
	einfo
	einfo "or for the post upgrade instructions, do"
	einfo
	einfo "    webapp-config --show-postupgrade ${PN} ${PVR}"
	einfo
	einfo "\033[1;32m**************************************************\033[00m"
	einfo
}
