# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_musicindex/mod_musicindex-1.4.1.ebuild,v 1.2 2014/12/17 14:24:51 pacho Exp $

EAPI=5

inherit apache-module

DESCRIPTION="mod_musicindex allows nice displaying of directories containing music files"
HOMEPAGE="http://www.parisc-linux.org/~varenet/musicindex/"
SRC_URI="http://hacks.slashdirt.org/musicindex/${P}.tar.gz
	http://validator.w3.org/feed/images/valid-rss.png -> ${P}_valid-rss.png
	http://jigsaw.w3.org/css-validator/images/vcss -> ${P}_vcss
	http://www.w3.org/Icons/valid-xhtml11 -> ${P}_valid-xhtml11"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mp3 +mp4 +flac +vorbis +cache mysql archive"

DEPEND="mp3? ( media-libs/libmad media-libs/libid3tag )
	mp4? ( media-libs/libmp4v2:0 )
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis )
	archive? ( app-arch/libarchive )
	mysql? ( virtual/mysql )"
RDEPEND="${DEPEND}
	sys-devel/libtool"

APACHE2_MOD_CONF="50_${PN}"
APACHE2_MOD_DEFINE="MUSICINDEX"
DOCFILES="AUTHORS BUGS ChangeLog README UPGRADING"

need_apache2

src_configure() {
	econf \
		$(use_enable mp3) \
		$(use_enable mp4) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable archive) \
		$(use_enable cache filecache) \
		$(use_enable mysql mysqlcache)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	apache-module_src_install

	# install W3C images
	insinto /usr/share/mod_musicindex
	newins "${DISTDIR}/${P}_valid-rss.png" valid-rss.png
	newins "${DISTDIR}/${P}_valid-xhtml11" valid-xhtml11
	newins "${DISTDIR}/${P}_vcss" vcss
}
