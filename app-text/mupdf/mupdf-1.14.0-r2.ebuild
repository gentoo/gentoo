# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs xdg

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="https://mupdf.com/"
SRC_URI="https://mupdf.com/downloads/archive/${P}-source.tar.xz"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 s390 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="X curl +javascript libressl opengl +ssl static-libs +vanilla"

RDEPEND="
	>=dev-lang/mujs-1.0.4
	media-libs/freetype:2=[static-libs?]
	media-libs/harfbuzz:=[static-libs?]
	media-libs/jbig2dec:=[static-libs?]
	media-libs/libpng:0=[static-libs?]
	>=media-libs/openjpeg-2.1:2=[static-libs?]
	virtual/jpeg[static-libs?]
	curl? ( net-misc/curl[static-libs?] )
	opengl? ( >=media-libs/freeglut-3.0.0:= )
	ssl? (
		libressl? ( dev-libs/libressl:0=[static-libs?] )
		!libressl? ( dev-libs/openssl:0=[static-libs?] )
	)
	X? (
		x11-libs/libX11[static-libs?]
		x11-libs/libXext[static-libs?]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="
	opengl? ( !static-libs )
	curl? ( X )"

S=${WORKDIR}/${P}-source

PATCHES=(
	"${FILESDIR}"/${PN}-1.14-CFLAGS.patch
	"${FILESDIR}"/${PN}-1.14-Makefile.patch
	"${FILESDIR}"/${PN}-1.10a-add-desktop-pc-xpm-files.patch
	# See bug #662352
	"${FILESDIR}"/${PN}-1.14-openssl-curl-x11.patch
	# bug #672998
	"${FILESDIR}"/${PN}-1.14-fix-big-endian.patch
)

src_prepare() {
	xdg_src_prepare
	use hppa && append-cflags -ffunction-sections

	use javascript || \
		sed -e '/* #define FZ_ENABLE_JS/ a\#define FZ_ENABLE_JS 0' \
			-i include/mupdf/fitz/config.h

	use vanilla || eapply \
		"${FILESDIR}"/${PN}-1.3-zoom-2.patch

	sed -e "1iOS = Linux" \
		-e "1iCC = $(tc-getCC)" \
		-e "1iLD = $(tc-getLD)" \
		-e "1iAR = $(tc-getAR)" \
		-e "1iverbose = yes" \
		-e "1ibuild = debug" \
		-e "1iprefix = ${ED}usr" \
		-e "1ilibdir = ${ED}usr/$(get_libdir)" \
		-e "1idocdir = ${ED}usr/share/doc/${PF}" \
		-i Makerules || die
}

_emake() {
	# When HAVE_OBJCOPY is yes, we end up with a lot of QA warnings.
	emake \
		GENTOO_PV=${PV} \
		HAVE_GLUT=$(usex opengl yes no) \
		WANT_CURL=$(usex curl) \
		WANT_OPENSSL=$(usex ssl) \
		WANT_X11=$(usex X) \
		USE_SYSTEM_LIBS=yes \
		USE_SYSTEM_MUJS=yes \
		HAVE_OBJCOPY=no \
		"$@"
}

src_compile() {
	_emake XCFLAGS="-fpic"

	use curl && _emake extra-apps

	use static-libs && \
		_emake build/debug/lib${PN}.a
}

src_install() {
	if use X || use opengl ; then
		domenu platform/debian/${PN}.desktop
		doicon platform/debian/${PN}.xpm
	else
		rm docs/man/${PN}.1
	fi

	_emake install

	dosym libmupdf.so.${PV} /usr/$(get_libdir)/lib${PN}.so

	use static-libs && \
		dolib.a build/debug/lib${PN}.a
	if use opengl ; then
		einfo "mupdf symlink points to mupdf-gl (bug 616654)"
		dosym ${PN}-gl /usr/bin/${PN}
	elif use X ; then
		einfo "mupdf symlink points to mupdf-x11 (bug 616654)"
		dosym ${PN}-x11 /usr/bin/${PN}
	fi
	use curl && dobin build/debug/${PN}-x11-curl
	insinto /usr/$(get_libdir)/pkgconfig
	doins platform/debian/${PN}.pc

	dodoc README CHANGES CONTRIBUTORS
}
