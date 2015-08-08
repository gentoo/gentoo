# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Extended dvipdfmx for use with XeTeX and other unicode TeXs"
HOMEPAGE="http://scripts.sil.org/svn-view/xdvipdfmx/
	http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="!<app-text/texlive-core-2010
	dev-libs/kpathsea
	sys-libs/zlib
	media-libs/freetype:2
	>=media-libs/libpng-1.2.43-r2:0=
	app-text/libpaper"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
# for dvipdfmx.cfg
RDEPEND="${RDEPEND}
	app-text/dvipdfmx"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

src_configure() {
	# don't do OSX stuff as it breaks on using long gone freetype funcs
	export kpse_cv_have_ApplicationServices=no

	econf \
		--with-system-kpathsea \
		--with-system-zlib \
		--with-system-libpng \
		--with-system-freetype2
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README AUTHORS ChangeLog
}
