# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Convertor written in Perl that converts LATEX documents to HTML"
HOMEPAGE="http://www.latex2html.org/"
SRC_URI="http://mirrors.ctan.org/support/latex2html/latex2html-2015.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="gif png"

DEPEND="app-text/ghostscript-gpl
	virtual/latex-base
	media-libs/netpbm
	dev-lang/perl
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng:0 )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}"-{convert-length,perl_name,extract-major-version-2,destdir}.patch )

src_prepare() {
	default

	# Dont install old url.sty and other files
	# Bug #240980
	rm texinputs/url.sty texinputs/latin9.def \
		|| die "failed to remove duplicate latex files"

	sed -i -e 's%@PERL@%'"${EPREFIX}"'/usr/bin/perl%g' wrapper/unix.pin || die
}

src_configure() {
	local myconf

	use gif || use png || myconf="${myconf} --disable-images"

	econf --libdir="${EPREFIX}"/usr/$(get_libdir)/latex2html \
		--shlibdir="${EPREFIX}"/usr/$(get_libdir)/latex2html \
		--enable-pk \
		--enable-eps \
		--enable-reverse \
		--enable-pipes \
		--enable-paths \
		--enable-wrapper \
		--with-texpath="${EPREFIX}"/usr/share/texmf-site/tex/latex/html \
		--without-mktexlsr \
		$(use_enable gif) \
		$(use_enable png) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	# make /usr/share/latex2html sticky
	keepdir /usr/share/latex2html

	# clean the perl scripts up to remove references to the sandbox
	local dir="${ED}/usr/$(get_libdir)/latex2html"
	if use png || use gif; then
		# pstoimg isn't built unless gif or png useflags are enabled
		sed -i -e "s:${T}:/tmp:g" "${dir}"/pstoimg.pl || die
	fi
	sed -i -e "s:${S}::g" "${dir}"/latex2html.pl || die
	sed -i -e "s:${T}:/tmp:g" "${dir}"/cfgcache.pm || die
	sed -i -e "s:${T}:/tmp:g" "${dir}"/l2hconf.pm || die

	dodoc BUGS Changes FAQ MANIFEST README TODO
}

pkg_postinst() {
	"${EROOT}"/usr/bin/mktexlsr
}

pkg_postrm() {
	"${EROOT}"/usr/bin/mktexlsr
}
