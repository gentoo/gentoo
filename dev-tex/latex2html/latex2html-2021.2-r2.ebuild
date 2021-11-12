# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Convertor written in Perl that converts LaTeX documents to HTML"
HOMEPAGE="https://www.latex2html.org/"
SRC_URI="https://github.com/latex2html/latex2html/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="gif png"

DEPEND="
	app-text/ghostscript-gpl
	virtual/latex-base
	>=media-libs/netpbm-10.86.24
	dev-lang/perl
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng:0 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2021.2-fix-PNMCROPOPT.patch
	"${FILESDIR}"/${PN}-2021.2-respect-DESTDIR.patch
)

src_prepare() {
	default

	sed -i -e 's%@PERL@%'"${EPREFIX}"'/usr/bin/perl%g' wrapper/unix.pin || die
}

src_configure() {
	local myconf

	use gif || use png || myconf+=" --disable-images"

	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/latex2html \
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

	dodoc BUGS Changes FAQ MANIFEST README.md TODO
}

pkg_postinst() {
	"${EROOT}"/usr/bin/mktexlsr
}

pkg_postrm() {
	"${EROOT}"/usr/bin/mktexlsr
}
