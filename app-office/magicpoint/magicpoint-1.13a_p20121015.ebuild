# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools elisp-common eutils toolchain-funcs

MY_SNAP="${PV/*_p}"
MY_P="mgp-snap-${MY_SNAP}"
DESCRIPTION="An X11 based presentation tool"
SRC_URI="ftp://sh.wide.ad.jp/WIDE/free-ware/mgp-snap/${MY_P}.tar.gz"
HOMEPAGE="http://member.wide.ad.jp/wg/mgp/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk contrib doc emacs examples gif imlib m17n-lib mng nls png truetype"

REQUIRED_USE="imlib? ( !gif !png )"
S="${WORKDIR}/kit"

COMMON_DEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXrender
	x11-libs/libXmu
	imlib? ( media-libs/imlib2 )
	!imlib? (
		gif? ( media-libs/giflib:= )
		png? ( >=media-libs/libpng-1.4:0= )
	)
	truetype? ( x11-libs/libXft )
	emacs? ( virtual/emacs )
	m17n-lib? ( dev-libs/m17n-lib )
	mng? ( media-libs/libmng )"
DEPEND="${COMMON_DEPEND}
	sys-devel/autoconf
	x11-proto/xextproto
	x11-libs/libxkbfile
	app-text/rman
	x11-misc/imake"
RDEPEND="${COMMON_DEPEND}
	contrib? ( dev-lang/perl )
	nls? ( sys-devel/gettext )
	truetype? ( cjk? ( media-fonts/sazanami ) )"

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	sed -i -e '/mgp_version =/s, (.*), ('${MY_SNAP}'),' mgp.c

	epatch \
		"${FILESDIR}"/${PN}-1.11b-gentoo.diff \
		"${FILESDIR}"/${PN}-1.13a_p20121015-parse-empty.patch \
		"${FILESDIR}"/${PN}-1.13a_p20121015-draw-charset.patch \
		"${FILESDIR}"/${PN}-1.13a_p20121015-draw-stringtoolong.patch \
		"${FILESDIR}"/${PN}-1.13a_p20121015-implicit-declaration.patch

	if ! use imlib; then
		epatch "${FILESDIR}"/${PN}-1.13a-libpng15.patch

		# fix compability with libpng14
		sed -i \
			-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:' \
			configure.in image/png.c || die

		if use gif; then
			# bug #85720
			sed -i -e "s/ungif/gif/g" configure.in || die

			# bug #486248
			epatch "${FILESDIR}"/${PN}-1.13a_p20121015-any-giflib.patch

			# fix use of uninitialized memory in error message
			epatch "${FILESDIR}"/${PN}-1.13a_p20121015-gif-dimension.patch
		fi
	fi

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
	# no parallel build possible anywhere
	emake -j1 Makefiles

	tc-export CC
	emake -j1 \
		CC="${CC}" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		BINDIR=/usr/bin \
		LIBDIR=/etc/X11

	if use emacs; then
		pushd contrib || die
		elisp-compile *.el || die
		popd
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

	use contrib && dobin contrib/mgp2{html,latex}.pl

	if use emacs; then
		pushd contrib || die
		elisp-install ${PN} *.el *.elc || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		popd
	fi

	dodoc FAQ README* RELNOTES SYNTAX TODO* USAGE*

	if use examples; then
		pushd sample || die
		insinto /usr/share/doc/${PF}/examples
		doins README* cloud.jpg dad.* embed*.mgp gradation*.mgp \
			mgp-old*.jpg mgp.mng mgp3.xbm mgprc-sample \
			multilingual.mgp sample*.mgp sendmail6*.mgp \
			tutorial*.mgp v6*.mgp v6header.*
		popd
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
