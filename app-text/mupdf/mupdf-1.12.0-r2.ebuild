# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs xdg

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="https://mupdf.com/"
SRC_URI="https://mupdf.com/downloads/${P}-source.tar.gz"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="X +curl javascript lcms libressl opengl +openssl static static-libs vanilla"

LIB_DEPEND="
	!libressl? ( dev-libs/openssl:0=[static-libs?] )
	libressl? ( dev-libs/libressl:0=[static-libs?] )
	javascript? ( >=dev-lang/mujs-0_p20160504 )
	media-libs/freetype:2=[static-libs?]
	media-libs/harfbuzz:=[static-libs?]
	media-libs/jbig2dec:=[static-libs?]
	media-libs/libpng:0=[static-libs?]
	>=media-libs/openjpeg-2.1:2=[static-libs?]
	net-misc/curl[static-libs?]
	virtual/jpeg[static-libs?]
	X? ( x11-libs/libX11[static-libs?]
		x11-libs/libXext[static-libs?] )
	opengl? ( >=media-libs/freeglut-3.0.0:= )"
RDEPEND="${LIB_DEPEND}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	static-libs? ( ${LIB_DEPEND} )
	static? ( ${LIB_DEPEND//?}
		app-arch/bzip2[static-libs]
		x11-libs/libXau[static-libs]
		x11-libs/libXdmcp[static-libs]
		x11-libs/libxcb[static-libs] )"

REQUIRED_USE="opengl? ( !static !static-libs )"

S=${WORKDIR}/${P}-source

PATCHES=(
		"${FILESDIR}"/${PN}-1.12-CFLAGS.patch
		"${FILESDIR}"/${PN}-1.9a-debug-build.patch
		"${FILESDIR}"/${PN}-1.10a-add-desktop-pc-xpm-files.patch
		"${FILESDIR}"/${PN}-1.11-openssl-curl-x11-r1.patch
		"${FILESDIR}"/${PN}-1.11-drop-libmupdfthird.patch
)

src_prepare() {
	xdg_src_prepare
	use hppa && append-cflags -ffunction-sections

	# specialized lcms2, keep it if wanted inside lubmupdfthird
	if ! use lcms ; then
		rm -rf thirdparty/lcms2
	fi

	rm -rf thirdparty/{README,curl,freeglut,freetype,harfbuzz,jbig2dec,libjpeg,mujs,openjpeg,zlib} || die
	for my_third in thirdparty/* ; do
		ewarn "Bundled thirdparty lib: ${my_third}"
	done

	if has_version ">=media-libs/openjpeg-2.1:2" ; then
		# Remove a switch, which prevents using shared libraries for openjpeg2.
		# See http://www.linuxfromscratch.org/blfs/view/cvs/pst/mupdf.html
		sed '/OPJ_STATIC$/d' -i source/fitz/load-jpx.c
	fi

	use javascript || \
		sed -e '/* #define FZ_ENABLE_JS/ a\#define FZ_ENABLE_JS 0' \
			-i include/mupdf/fitz/config.h

	sed -e "/^libdir=/s:/lib:/$(get_libdir):" \
		-e "/^prefix=/s:=.*:=${EROOT}/usr:" \
		-i platform/debian/${PN}.pc || die

	use vanilla || eapply \
		"${FILESDIR}"/${PN}-1.3-zoom-2.patch

	sed -e "1iOS = Linux" \
		-e "1iCC = $(tc-getCC)" \
		-e "1iLD = $(tc-getCC)" \
		-e "1iAR = $(tc-getAR)" \
		-e "1iverbose = yes" \
		-e "1ibuild = debug" \
		-e "1iprefix = ${ED}usr" \
		-e "1ilibdir = ${ED}usr/$(get_libdir)" \
		-e "1idocdir = ${ED}usr/share/doc/${PF}" \
		-i Makerules || die

	if use static-libs || use static ; then
		cp -a "${S}" "${S}"-static || die
		#add missing Libs.private for xcb and freetype
		sed -e 's:\(pkg-config --libs\):\1 --static:' \
			-e '/^SYS_X11_LIBS = /s:\(.*\):\1 -lpthread:' \
			-e '/^SYS_FREETYPE_LIBS = /s:\(.*\):\1 -lbz2:' \
			-i "${S}"-static/Makerules || die
	fi

	my_soname=libmupdf.so.${PV}
	my_soname_js_none=libmupdf-js-none.so.${PV}
	sed -e "\$a\$(MUPDF_LIB): \$(MUPDF_JS_NONE_LIB)" \
		-e "\$a\\\t\$(QUIET_LINK) \$(CC) \$(LDFLAGS) --shared -Wl,-soname -Wl,${my_soname} -Wl,--no-undefined -o \$@ \$^ \$(MUPDF_JS_NONE_LIB) \$(LIBS)" \
		-e "/^MUPDF_LIB =/s:=.*:= \$(OUT)/${my_soname}:" \
		-e "\$a\$(MUPDF_JS_NONE_LIB):" \
		-e "\$a\\\t\$(QUIET_LINK) \$(CC) \$(LDFLAGS) --shared -Wl,-soname -Wl,${my_soname_js_none} -Wl,--no-undefined -o \$@ \$^ \$(LIBS)" \
		-e "/install/s: COPYING : :" \
		-i Makefile || die
}

src_compile() {
	use lcms && emake XCFLAGS="-fpic" third
	emake XCFLAGS="-fpic" \
		HAVE_GLUT=$(usex opengl yes no) \
		HAVE_MUJS=$(usex javascript) \
		MUJS_LIBS=$(usex javascript -lmujs '') \
		WANT_CURL=$(usex curl) \
		WANT_OPENSSL=$(usex openssl) \
		WANT_X11=$(usex X)

	use static-libs && \
		emake -C "${S}"-static build/debug/lib${PN}{,-js-none}.a
	use static && \
		emake -C "${S}"-static XLIBS="-static"
}

src_install() {
	if use X || use opengl ; then
		domenu platform/debian/${PN}.desktop
		doicon platform/debian/${PN}.xpm
	else
		rm docs/man/${PN}.1
	fi

	emake install \
		HAVE_GLUT=$(usex opengl yes no) \
		HAVE_MUJS=$(usex javascript) \
		MUJS_LIBS=$(usex javascript -lmujs '') \
		WANT_CURL=$(usex curl) \
		WANT_OPENSSL=$(usex openssl) \
		WANT_X11=$(usex X)

	dosym ${my_soname} /usr/$(get_libdir)/lib${PN}.so

	use static-libs && \
		dolib.a "${S}"-static/build/debug/lib${PN}{,-js-none}.a
	if use static ; then
		dobin "${S}"-static/build/debug/mu{tool,draw}
		use X && dobin "${S}"-static/build/debug/${PN}-x11
	fi
	if use opengl ; then
		einfo "mupdf symlink points to mupdf-gl (bug 616654)"
		dosym ${PN}-gl /usr/bin/${PN}
	elif use X ; then
		einfo "mupdf symlink points to mupdf-x11 (bug 616654)"
		dosym ${PN}-x11 /usr/bin/${PN}
	fi
	insinto /usr/$(get_libdir)/pkgconfig
	doins platform/debian/${PN}.pc

	dodoc README CHANGES CONTRIBUTORS
}
