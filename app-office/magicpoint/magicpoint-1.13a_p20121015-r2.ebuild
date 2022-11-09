# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common toolchain-funcs

MY_SNAP="${PV/*_p}"
MY_P="mgp-snap-${MY_SNAP}"

DESCRIPTION="X11 based presentation tool"
HOMEPAGE="http://member.wide.ad.jp/wg/mgp/"
SRC_URI="ftp://sh.wide.ad.jp/WIDE/free-ware/mgp-snap/${MY_P}.tar.gz"
S="${WORKDIR}/kit"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk contrib doc emacs examples fontconfig gif imlib m17n-lib mng nls png truetype"
REQUIRED_USE="imlib? ( !gif !png )"

COMMON_DEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libXrender
	emacs? ( >=app-editors/emacs-23.1:* )
	imlib? ( media-libs/imlib2[X] )
	!imlib? (
		gif? ( media-libs/giflib:= )
		png? ( >=media-libs/libpng-1.4:0= )
	)
	m17n-lib? (
		dev-libs/m17n-lib[X]
		fontconfig? ( media-libs/fontconfig )
	)
	mng? ( media-libs/libmng:= )
	truetype? (
		x11-libs/libXft
		media-libs/fontconfig
	)"
RDEPEND="
	${COMMON_DEPEND}
	contrib? ( dev-lang/perl )
	nls? ( sys-devel/gettext )
	truetype? ( cjk? ( media-fonts/sazanami ) )"
DEPEND="
	${COMMON_DEPEND}
	x11-libs/libxkbfile"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	virtual/pkgconfig
	x11-base/xorg-proto
	>=x11-misc/imake-1.0.8-r1
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11b-gentoo.diff
	"${FILESDIR}"/${PN}-1.13a_p20121015-fontconfig.patch
	"${FILESDIR}"/${PN}-1.13a_p20121015-parse-empty.patch
	"${FILESDIR}"/${PN}-1.13a_p20121015-draw-charset.patch
	"${FILESDIR}"/${PN}-1.13a_p20121015-draw-stringtoolong.patch
	"${FILESDIR}"/${PN}-1.13a_p20121015-implicit-declaration.patch
	"${FILESDIR}"/${PN}-1.13a_p20121015-fno-common.patch
)

src_prepare() {
	default

	sed -i -e '/mgp_version =/s, (.*), ('${MY_SNAP}'),' mgp.c || die

	if ! use imlib; then
		eapply "${FILESDIR}"/${PN}-1.13a-libpng15.patch

		# fix compability with libpng14
		sed -i \
			-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:' \
			configure.in image/png.c || die

		if use gif; then
			# bug #85720
			sed -i -e "s/ungif/gif/g" configure.in || die

			# bug #486248
			eapply "${FILESDIR}"/${PN}-1.13a_p20121015-any-giflib.patch

			# fix use of uninitialized memory in error message
			eapply "${FILESDIR}"/${PN}-1.13a_p20121015-gif-dimension.patch
		fi
	fi

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gif)
		$(use_enable imlib)
		$(use_enable nls locale)
		$(use_enable truetype xft2)
		$(use_with m17n-lib)
		--disable-freetype
		--disable-vflib
		--x-libraries="${ESYSROOT}/usr/$(get_libdir)"
		--x-includes="${ESYSROOT}/usr/include"
	)

	tc-export PKG_CONFIG

	econf "${myeconfargs[@]}"

	export IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}"
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" xmkmf || die
}

src_compile() {
	# no parallel build possible anywhere
	emake -j1 CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" Makefiles

	local myemakeargs=(
		AR="$(tc-getAR) cq"
		CC="$(tc-getCC)"
		RANLIB="$(tc-getRANLIB)"
		CDEBUGFLAGS="${CFLAGS}"
		LOCAL_LDFLAGS="${LDFLAGS}"
		BINDIR="${EPREFIX}/usr/bin"
		LIBDIR="${EPREFIX}/etc/X11"
	)
	emake -j1 "${myemakeargs[@]}"

	if use emacs; then
		pushd contrib >/dev/null || die
		elisp-compile *.el
		popd >/dev/null || die
	fi
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		BINDIR="${EPREFIX}/usr/bin"
		DOCHTMLDIR="${EPREFIX}/usr/share/doc/${PF}"
		LIBDIR="${EPREFIX}/etc/X11"
		MANPATH="${EPREFIX}/usr/share/man"
		MANSUFFIX=1
	)
	emake -j1 "${myemakeargs[@]}" install install.man

	use contrib && dobin contrib/mgp2{html,latex}.pl

	if use emacs; then
		pushd contrib >/dev/null || die
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		popd >/dev/null || die
	fi

	dodoc FAQ README* RELNOTES SYNTAX TODO* USAGE*

	if use examples; then
		# default and mgp[1-3].jpg are already installed
		rm sample/{default.mgp,mgp{1,2,3}.jpg} || die
		docinto examples
		dodoc sample/[^IM]*
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
