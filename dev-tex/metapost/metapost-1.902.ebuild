# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/metapost/metapost-1.902.ebuild,v 1.1 2015/07/15 09:48:06 aballier Exp $

EAPI=5

inherit flag-o-matic toolchain-funcs

DESCRIPTION="System for producing graphics"
HOMEPAGE="http://tug.org/metapost.html"
SRC_URI="https://foundry.supelec.fr/frs/download.php/file/15766/${P}-src.tar.bz2"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-libs/kpathsea-6.1.0_p20120701
	>=app-eselect/eselect-mpost-0.3
	>=x11-libs/cairo-1.12
	>x11-libs/pixman-0.18
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}/source/texk/web2c

src_configure() {
	has_version '>=dev-libs/kpathsea-6.2.1' && append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"
	econf \
		--disable-all-pkgs \
		--enable-shared    \
		--disable-largefile \
		--disable-ptex \
		--enable-mp  \
		--with-system-cairo \
		--with-system-libpng \
		--without-ptexenc \
		--with-system-kpathsea \
		--with-system-xpdf \
		--with-system-freetype \
		--with-system-freetype2 \
		--with-system-gd \
		--with-system-teckit \
		--with-system-t1lib \
		--with-system-icu \
		--with-system-graphite \
		--with-system-zziplib \
		--with-system-poppler \
		--with-system-zlib \
		--with-system-pixman \
		--disable-native-texlive-build \
		--without-mf-x-toolkit --without-x
}

src_compile() {
	emake mpost
}

src_install() {
	emake DESTDIR="${D}" \
		SUBDIRS="" \
		bin_PROGRAMS="mpost" \
		nodist_man_MANS="" \
		dist_man_MANS="" \
		install-binPROGRAMS
	# Rename it
	mv "${D}/usr/bin/mpost" "${D}/usr/bin/mpost-${P}" || die "renaming failed"

	cd "${WORKDIR}/${P}"
	dodoc README CHANGES
}

pkg_postinst(){
	einfo "Calling eselect mpost update"
	eselect mpost update
}
