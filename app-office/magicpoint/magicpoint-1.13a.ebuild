# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/magicpoint/magicpoint-1.13a.ebuild,v 1.8 2011/09/14 16:10:59 ssuominen Exp $

EAPI=4
inherit autotools elisp-common eutils fixheadtails toolchain-funcs

DESCRIPTION="An X11 based presentation tool"
SRC_URI="ftp://sh.wide.ad.jp/WIDE/free-ware/mgp/${P}.tar.gz
	ftp://ftp.mew.org/pub/MagicPoint/${P}.tar.gz"
HOMEPAGE="http://member.wide.ad.jp/wg/mgp/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ~sparc x86"
IUSE="cjk doc emacs examples gif imlib m17n-lib mng nls truetype"

MY_DEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXrender
	x11-libs/libXmu
	>=media-libs/libpng-1.4
	gif? ( >=media-libs/giflib-4.0.1 )
	imlib? ( media-libs/imlib )
	truetype? ( x11-libs/libXft )
	emacs? ( virtual/emacs )
	m17n-lib? ( dev-libs/m17n-lib )
	mng? ( media-libs/libmng )"
DEPEND="${MY_DEPEND}
	sys-devel/autoconf
	x11-proto/xextproto
	x11-libs/libxkbfile
	app-text/rman
	x11-misc/imake"
RDEPEND="${MY_DEPEND}
	nls? ( sys-devel/gettext )
	truetype? ( cjk? ( media-fonts/sazanami ) )"

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.11b-gentoo.diff \
		"${FILESDIR}"/${P}-implicit-declaration.patch \
		"${FILESDIR}"/${P}-libpng15.patch

	# fix compability with libpng14
	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:' \
		configure.in image/png.c || die

	# bug #85720
	sed -i -e "s/ungif/gif/g" configure.in || die
	ht_fix_file configure.in
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gif) \
		$(use_enable imlib) \
		$(use_enable nls locale) \
		$(use_enable truetype xft2) \
		$(use_with m17n-lib) \
		--disable-vflib \
		--disable-freetype \
		--x-libraries=/usr/lib/X11 \
		--x-includes=/usr/include/X11
}

src_compile() {
	xmkmf || die
	# no parallel build possibly, anywhere
	emake -j1 Makefiles
	emake -j1 clean
	tc-export CC
	emake -j1 CC="${CC}" CDEBUGFLAGS="${CFLAGS}" LOCAL_LDFLAGS="${LDFLAGS}" \
		BINDIR=/usr/bin LIBDIR=/etc/X11
	if use emacs; then
	   cd contrib/
	   elisp-compile *.el || die
	fi
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		BINDIR=/usr/bin \
		LIBDIR=/etc/X11 \
		install

	emake -j1 \
		DESTDIR="${D}" \
		DOCHTMLDIR=/usr/share/doc/${PF} \
		MANPATH=/usr/share/man \
		MANSUFFIX=1 \
		install.man

	dobin contrib/{mgp2html.pl,mgp2latex.pl}

	if use emacs; then
		cd contrib/
		elisp-install ${PN} *.el *.elc || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		cd -
	fi

	use doc && dodoc FAQ README* RELNOTES SYNTAX TODO* USAGE*

	if use examples; then
		cd sample
		insinto /usr/share/${PF}/sample
		doins README* cloud.jpg dad.* embed*.mgp gradation*.mgp \
			mgp-old*.jpg mgp.mng mgp3.xbm mgprc-sample \
			multilingual.mgp sample*.mgp sendmail6*.mgp \
			tutorial*.mgp v6*.mgp v6header.*
	fi
}

pkg_postinst() {
	elog
	elog "If you enabled xft2 support (default) you may specify xfont directive by"
	elog "font name and font registry."
	elog "e.g.)"
	elog '%deffont "standard" xfont "sazanami mincho" "jisx0208.1983"'
	elog
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
