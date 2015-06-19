# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ttf2pk2/ttf2pk2-1.5_p20130530.ebuild,v 1.1 2013/06/25 21:30:29 aballier Exp $

EAPI=4

DESCRIPTION="Freetype 2 based TrueType font to TeX's PK format converter"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Note about blockers: it is a freetype2 based replacement for ttf2pk and
# ttf2tfm from freetype1, so block freetype1.
# It installs some data that collides with
# dev-texlive/texlive-langcjk-2011[source]. Hope it'd be fixed with 2012,
# meanwhile we can start dropping freetype1.
RDEPEND=">=dev-libs/kpathsea-6.1.0_p20120701
		media-libs/freetype:2
		sys-libs/zlib
		!media-libs/freetype:1
		!=dev-texlive/texlive-langcjk-2011*[source]"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

src_configure() {
	econf --with-system-kpathsea \
		--with-system-freetype2 \
		--with-system-zlib
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc BUGS README TODO ChangeLog
}
