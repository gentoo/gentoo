# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"

inherit autotools flag-o-matic wxwidgets xdg

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
	https://dev.gentoo.org/~leio/distfiles/${P}-fortran.tar.xz
	https://dev.gentoo.org/~leio/distfiles/${P}-fortran-update-v1.7.tar.xz
	https://dev.gentoo.org/~leio/distfiles/${P}-fortran-update-v1.8.tar.xz
	https://dev.gentoo.org/~leio/distfiles/${P}-codecompletion-symbolbrowser-update.tar.xz
"

# USE="fortran" enables FortranProject plugin (updated to v1.8 2021-05-29 [r230])
# that is delivered with Code::Blocks 20.03 source code.
# https://sourceforge.net/projects/fortranproject
# https://cbfortran.sourceforge.io

IUSE="contrib debug fortran"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-arch/zip
	dev-libs/glib:2
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.1-r2:0/3.1
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-arch/bzip2
		app-text/hunspell:=
		dev-libs/boost:=
		dev-libs/libgamin
		media-libs/fontconfig
		sys-libs/zlib
	)"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-env.patch
	"${WORKDIR}"/patches/
	"${FILESDIR}"/${P}_fix_DoxyBlocks_startup_segfault.patch
	"${FILESDIR}"/${P}_Scintilla_fix_buffer_over-read_with_absolute_reference.patch
	)

src_prepare() {
	default
	# Force to use bundled Squirrel-3.1 (patched version is used by upstream) due to it's API was changed
	sed -i '/PKG_CHECK_MODULES(\[SQUIRREL\]/c\HAVE_SQUIRREL=no' configure.ac || die # Bug 884601
	eautoreconf
}

src_configure() {
	# Bug 858338
	append-flags -fno-strict-aliasing

	setup-wxwidgets

	# USE="contrib -fortran" setup:
	use fortran || CONF_WITH_LST=$(use_with contrib contrib-plugins all,-FortranProject)
	# USE="contrib fortran" setup:
	use fortran && CONF_WITH_LST=$(use_with contrib contrib-plugins all)
	# USE="-contrib fortran" setup:
	use contrib || CONF_WITH_LST=$(use_with fortran contrib-plugins FortranProject)

	local myeconfargs=(
		--disable-pch
		$(use_with contrib boost-libdir "${ESYSROOT}/usr/$(get_libdir)")
		$(use_enable debug)
		${CONF_WITH_LST}
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
