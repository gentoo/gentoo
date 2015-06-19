# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mupdf/mupdf-1.3_p20140118.ebuild,v 1.11 2014/12/09 05:48:03 zlogene Exp $

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs vcs-snapshot

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="http://mupdf.com/"
SRC_URI="http://git.ghostscript.com/?p=mupdf.git;a=snapshot;h=01f0a0db15faf4bffaa2556ced74868572dac7f5;sf=tgz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0/1.3"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="X vanilla static static-libs"

LIB_DEPEND="dev-libs/openssl[static-libs?]
	media-libs/freetype:2[static-libs?]
	media-libs/jbig2dec[static-libs?]
	<media-libs/openjpeg-2.1:2[static-libs?]
	net-misc/curl[static-libs?]
	virtual/jpeg[static-libs?]
	X? ( x11-libs/libX11[static-libs?]
		x11-libs/libXext[static-libs?] )"
RDEPEND="${LIB_DEPEND}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	static-libs? ( ${LIB_DEPEND} )
	static? ( ${LIB_DEPEND//?}
		app-arch/bzip2[static-libs]
		x11-libs/libXau[static-libs]
		x11-libs/libXdmcp[static-libs]
		x11-libs/libxcb[static-libs] )"

src_prepare() {
	rm -rf thirdparty || die

	epatch \
		"${FILESDIR}"/${PN}-1.3-CFLAGS.patch \
		"${FILESDIR}"/${PN}-1.3-openjpeg2.patch \
		"${FILESDIR}"/${PN}-1.3-pkg-config.patch \
		"${FILESDIR}"/${PN}-1.3-sys_curl.patch

	sed -e "/^libdir=/s:/lib:/$(get_libdir):" \
		-e "/^prefix=/s:=.*:=${EROOT}/usr:" \
		-i platform/debian/${PN}.pc || die

	use vanilla || epatch \
		"${FILESDIR}"/${PN}-1.3-zoom-2.patch \
		"${FILESDIR}"/${PN}-1.3-forward_back.patch

	#http://bugs.ghostscript.com/show_bug.cgi?id=693467
	sed -e '/^\(Actions\|MimeType\)=/s:\(.*\):\1;:' \
		-i platform/debian/${PN}.desktop || die

	sed -e "\$aOS = Linux" \
		-e "\$aCC = $(tc-getCC)" \
		-e "\$aLD = $(tc-getCC)" \
		-e "\$aAR = $(tc-getAR)" \
		-e "\$averbose = true" \
		-e "\$abuild = debug" \
		-e "\$aprefix = ${ED}usr" \
		-e "\$alibdir = ${ED}usr/$(get_libdir)" \
		-i Makerules || die

	if ! use X ; then
		sed -e "\$aNOX11 = yes" \
			-i Makerules || die
	fi

	if use static-libs || use static ; then
		cp -a "${S}" "${S}"-static || die
		#add missing Libs.private for xcb and freetype
		sed -e 's:\(pkg-config --libs\):\1 --static:' \
		    -e '/^SYS_X11_LIBS = /s:\(.*\):\1 -lpthread:' \
		    -e '/^SYS_FREETYPE_LIBS = /s:\(.*\):\1 -lbz2:' \
			-i "${S}"-static/Makerules || die
	fi

	my_soname=libmupdf.so.1.3
	my_soname_js_none=libmupdf-js-none.so.1.3
	sed -e "\$a\$(MUPDF_LIB): \$(MUPDF_JS_NONE_LIB)" \
		-e "\$a\\\t\$(QUIET_LINK) \$(CC) \$(LDFLAGS) --shared -Wl,-soname -Wl,${my_soname} -Wl,--no-undefined -o \$@ \$^ \$(MUPDF_JS_NONE_LIB) \$(LIBS)" \
		-e "/^MUPDF_LIB :=/s:=.*:= \$(OUT)/${my_soname}:" \
		-e "\$a\$(MUPDF_JS_NONE_LIB):" \
		-e "\$a\\\t\$(QUIET_LINK) \$(CC) \$(LDFLAGS) --shared -Wl,-soname -Wl,${my_soname_js_none} -Wl,--no-undefined -o \$@ \$^ \$(LIBS)" \
		-e "/^MUPDF_JS_NONE_LIB :=/s:=.*:= \$(OUT)/${my_soname_js_none}:" \
		-i Makefile || die
}

src_compile() {
	emake XCFLAGS="-fpic"
	use static-libs && \
		emake -C "${S}"-static build/debug/lib${PN}{,-js-none}.a
	use static && \
		emake -C "${S}"-static XLIBS="-static"
}

src_install() {
	if use X ; then
		domenu platform/debian/${PN}.desktop
		doicon platform/debian/${PN}.xpm
		dobin platform/debian/${PN}-select-file
	else
		rm docs/man/${PN}.1
	fi

	emake install
	dosym ${my_soname} /usr/$(get_libdir)/lib${PN}.so

	use static-libs && \
		dolib.a "${S}"-static/build/debug/lib${PN}{,-js-none}.a
	if use static ; then
		dobin "${S}"-static/build/debug/mu{tool,draw}
		use X && dobin "${S}"-static/build/debug/${PN}-x11
	fi
	use X && dosym ${PN}-x11 /usr/bin/${PN}

	insinto /usr/$(get_libdir)/pkgconfig
	doins platform/debian/${PN}.pc

	dodoc README docs/*.{txt,c}
}
