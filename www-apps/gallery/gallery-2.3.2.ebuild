# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/gallery/gallery-2.3.2.ebuild,v 1.8 2015/07/05 22:06:42 blueness Exp $

EAPI="5"

inherit webapp eutils depend.php confutils

DESCRIPTION="Web based (PHP Script) photo album viewer/creator"
HOMEPAGE="http://galleryproject.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="ffmpeg +gd imagemagick +mysql netpbm postgres raw sqlite unzip zip"

RDEPEND="raw? ( media-gfx/dcraw )
	ffmpeg? ( virtual/ffmpeg )
	imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
	netpbm? ( media-libs/netpbm media-gfx/jhead )
	unzip? ( app-arch/unzip )
	zip? ( app-arch/zip )
	sqlite? ( dev-lang/php[pdo] dev-lang/php[sqlite] )
	mysql? ( || ( dev-lang/php[mysql] dev-lang/php[mysqli] ) )
	dev-lang/php[session,postgres?,gd?]
	virtual/httpd-php"

S=${WORKDIR}/${PN}2

need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup
	confutils_require_any gd imagemagick netpbm
	confutils_require_any mysql postgres sqlite
}

src_install() {
	webapp_src_preinst

	dohtml README.html
	rm README.html LICENSE
	sed -i -e "/^LICENSE\>/d" -e "/^README\.html\>/d" MANIFEST

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_postinst_txt en "${FILESDIR}/postinstall-en2.txt"
	webapp_src_install
}

pkg_postinst() {
	elog "You are strongly encouraged to back up your database"
	elog "and the g2data directory, as upgrading may make"
	elog "irreversible changes to both."
	elog
	elog "g2data dir: cp -Rf /path/to/g2data/ /path/to/backup"
	elog "mysql: mysqldump --opt -u username -h hostname -p database > /path/to/backup.sql"
	elog "postgres: pg_dump -h hostname --format=t database > /path/to/backup.sql"
	webapp_pkg_postinst
}
