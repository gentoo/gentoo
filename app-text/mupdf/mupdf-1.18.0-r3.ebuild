# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs xdg

DESCRIPTION="A lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="https://mupdf.com/ https://git.ghostscript.com/?p=mupdf.git"
SRC_URI="https://mupdf.com/downloads/archive/${P}-source.tar.xz"
S="${WORKDIR}/${P}-source"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 ~x86"
IUSE="X +javascript libressl opengl ssl"
REQUIRED_USE="opengl? ( javascript )"

# Although we use the bundled, patched version of freeglut in mupdf (because of
# bug #653298), the best way to ensure that its dependencies are present is to
# install system's freeglut.
BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/gumbo
	media-libs/freetype:2=
	media-libs/harfbuzz:=[truetype]
	media-libs/jbig2dec:=
	media-libs/libpng:0=
	>=media-libs/openjpeg-2.1:2=
	virtual/jpeg
	javascript? ( >=dev-lang/mujs-1.0.7:= )
	opengl? ( >=media-libs/freeglut-3.0.0 )
	ssl? (
		libressl? ( >=dev-libs/libressl-3.1.4:0= )
		!libressl? ( >=dev-libs/openssl-1.1:0= )
	)
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.15-CFLAGS.patch
	"${FILESDIR}"/${PN}-1.18-Makefile.patch
	"${FILESDIR}"/${PN}-1.10a-add-desktop-pc-xpm-files.patch
	# See bugs #662352
	"${FILESDIR}"/${PN}-1.15-openssl-x11.patch
	# General cross fixes from Debian (refreshed)
	"${FILESDIR}"/${PN}-1.18.0-cross-fixes.patch
	# Additional security patches post-1.18.0
	"${FILESDIR}"/${P}-fix-oob-in-pdf-layer.c
	"${FILESDIR}"/${P}-fix-oob-in-pixmap.c
	"${FILESDIR}"/${P}-CVE-2021-3407.patch
)

src_prepare() {
	xdg_src_prepare

	use hppa && append-cflags -ffunction-sections

	append-cflags "-DFZ_ENABLE_JS=$(usex javascript 1 0)"

	sed -e "1iOS = Linux" \
		-e "1iCC = $(tc-getCC)" \
		-e "1iCXX = $(tc-getCXX)" \
		-e "1iLD = $(tc-getLD)" \
		-e "1iAR = $(tc-getAR)" \
		-e "1iverbose = yes" \
		-e "1ibuild = debug" \
		-e "1iprefix = ${ED}/usr" \
		-e "1ilibdir = ${ED}/usr/$(get_libdir)" \
		-e "1idocdir = ${ED}/usr/share/doc/${PF}" \
		-i Makerules || die
}

_emake() {
	# When HAVE_OBJCOPY is yes, we end up with a lot of QA warnings.
	# Bundled libs
	# * General
	# Note that USE_SYSTEM_LIBS=yes is a metaoption which will set to upstream's
	# recommendations. It does not mean "always use system libs".
	# See [0] below for what it means in a specific version.
	#
	# * freeglut
	# We don't use system's freeglut because upstream has a special modified
	# version of it that gives mupdf clipboard support. See bug #653298
	#
	# * mujs
	# As of v1.15.0, mupdf started using symbols in mujs that were not part
	# of any release. We then went back to using the bundled version of it.
	# But v1.17.0 looks ok, so we'll go unbundled again. Be aware of this risk
	# when bumping and check!
	# See bug #685244
	#
	# * lmms2
	# mupdf uses a bundled version of lcms2 [0] because Artifex have forked it [1].
	# It is therefore not appropriate for us to unbundle it at this time.
	#
	# [0] https://git.ghostscript.com/?p=mupdf.git;a=blob;f=Makethird;h=c4c540fa4a075df0db85e6fdaab809099881f35a;hb=HEAD#l9
	# [1] https://www.ghostscript.com/doc/lcms2mt/doc/WhyThisFork.txt
	emake \
		GENTOO_PV=${PV} \
		HAVE_GLUT=$(usex opengl) \
		HAVE_LIBCRYPTO=$(usex ssl) \
		HAVE_X11=$(usex X) \
		USE_SYSTEM_LIBS=yes \
		USE_SYSTEM_MUJS=$(usex javascript) \
		USE_SYSTEM_GLUT=no \
		HAVE_OBJCOPY=no \
		"$@"
}

src_compile() {
	_emake XCFLAGS="-fpic"
}

src_install() {
	if use X || use opengl ; then
		domenu platform/debian/${PN}.desktop
		doicon platform/debian/${PN}.xpm
	else
		rm docs/man/${PN}.1 || die
	fi

	_emake install

	dosym libmupdf.so.${PV} /usr/$(get_libdir)/lib${PN}.so

	if use opengl ; then
		einfo "mupdf symlink points to mupdf-gl (bug 616654)"
		dosym ${PN}-gl /usr/bin/${PN}
	elif use X ; then
		einfo "mupdf symlink points to mupdf-x11 (bug 616654)"
		dosym ${PN}-x11 /usr/bin/${PN}
	fi

	# Respect libdir (bug #734898)
	sed -i -e "s:/lib:/$(get_libdir):" platform/debian/${PN}.pc || die

	insinto /usr/$(get_libdir)/pkgconfig
	doins platform/debian/${PN}.pc

	dodoc README CHANGES CONTRIBUTORS
}
