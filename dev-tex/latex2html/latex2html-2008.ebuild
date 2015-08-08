# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

DESCRIPTION="convertor written in Perl that converts LATEX documents to HTML"
SRC_URI="http://saftsack.fs.uni-bayreuth.de/~latex2ht/current/${P}.tar.gz"
HOMEPAGE="http://www.latex2html.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="gif png"

DEPEND="app-text/ghostscript-gpl
	virtual/latex-base
	media-libs/netpbm
	dev-lang/perl
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-convert-length.patch"
	epatch "${FILESDIR}/${PN}-perl_name.patch"
	epatch "${FILESDIR}/${PN}-extract-major-version.patch"
	epatch "${FILESDIR}/${PN}-destdir.patch"
	# Dont install old url.sty and other files
	# Bug #240980
	rm -f texinputs/url.sty texinputs/latin9.def || die "failed to remove duplicate latex files"
}

src_compile() {
	local myconf

	use gif || use png || myconf="${myconf} --disable-images"

	econf --libdir=/usr/$(get_libdir)/latex2html \
		--shlibdir=/usr/$(get_libdir)/latex2html \
		--enable-pk \
		--enable-eps \
		--enable-reverse \
		--enable-pipes \
		--enable-paths \
		--enable-wrapper \
		--with-texpath=/usr/share/texmf-site/tex/latex/html \
		--without-mktexlsr \
		$(use_enable gif) \
		$(use_enable png) \
		${myconf} || die "econf failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc BUGS Changes FAQ LICENSE.orig MANIFEST README* TODO

	# make /usr/share/latex2html sticky
	keepdir /usr/share/latex2html

	# clean the perl scripts up to remove references to the sandbox
	einfo "fixing sandbox references"
	# pstoimg isn't built unless gif or png useflags are enabled
	{ use png || use gif ; } && dosed "s:${T}:/tmp:g" /usr/$(get_libdir)/latex2html/pstoimg.pl
	dosed "s:${S}::g" /usr/$(get_libdir)/latex2html/latex2html.pl
	dosed "s:${T}:/tmp:g" /usr/$(get_libdir)/latex2html/cfgcache.pm
	dosed "s:${T}:/tmp:g" /usr/$(get_libdir)/latex2html/l2hconf.pm
}

pkg_postinst() {
	einfo "Running ${ROOT}usr/bin/mktexlsr to rebuild ls-R database...."
	"${ROOT}"usr/bin/mktexlsr
}

pkg_postrm() {
	einfo "Running ${ROOT}usr/bin/mktexlsr to rebuild ls-R database...."
	"${ROOT}"usr/bin/mktexlsr
}
