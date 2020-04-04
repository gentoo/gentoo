# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

DESCRIPTION="PHP-based tool for managing,updating and playing audio files via a web interface"
HOMEPAGE="http://www.ampache.org/"
SRC_URI="https://github.com/ampache/ampache/archive/${PV}.tar.gz -> ${P}.tar.gz"

# Remove this and the SLOT line below if the code changes. Added for a dependency only change
WEBAPP_MANUAL_SLOT="yes"
SLOT="${PV}"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="aac flac mp3 ogg transcode"

RDEPEND="dev-lang/php[gd,hash(+),iconv,mysql,pdo,session,unicode,xml,zlib]
	transcode? ( media-sound/lame
		aac? ( || ( media-libs/faad2 media-sound/alac_decoder ) )
		flac? ( media-libs/flac )
		mp3? ( media-sound/mp3splt )
		ogg? ( media-sound/mp3splt media-sound/vorbis-tools )
	)"
DEPEND=""

need_httpd_cgi

src_install() {
	webapp_src_preinst

	doman docs/man/man1/ampache.1
	rm -rf docs/man || die "Unable to remove local man dir"

	dodoc docs/*
	rm -rf docs/ || die "Unable to remove local docs dir"

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_postinst_txt en "${FILESDIR}"/installdoc.txt
	webapp_src_install
}

pkg_postinst() {
	elog "Install and upgrade instructions can be found here:"
	elog "  /usr/share/doc/${P}/INSTALL.bz2"
	elog "  /usr/share/doc/${P}/MIGRATION.bz2"
	webapp_pkg_postinst
}
