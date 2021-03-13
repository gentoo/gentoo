# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit autotools wxwidgets xdg

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
https://dev.gentoo.org/~leio/distfiles/${P}-fortran.tar.xz
https://dev.gentoo.org/~leio/distfiles/${P}-fortran-update-v1.7.tar.xz"

# USE="fortran" enables FortranProject plugin (updated to v1.7 2020-06-07 [r298])
# that is delivered with Code::Blocks 20.03 source code.
# https://sourceforge.net/projects/fortranproject
# https://cbfortran.sourceforge.io

IUSE="contrib debug fortran pch"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-arch/zip
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.1-r2:0/3.1
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-text/hunspell
		dev-libs/boost:=
	)"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-env.patch
	"${FILESDIR}"/${P}_gcc11_compatibility.patch
	"${WORKDIR}"/patches/
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets

	# USE="contrib -fortran" setup:
	use fortran || CONF_WITH_LST=$(use_with contrib contrib-plugins all,-FortranProject)
	# USE="contrib fortran" setup:
	use fortran && CONF_WITH_LST=$(use_with contrib contrib-plugins all)
	# USE="-contrib fortran" setup:
	use contrib || CONF_WITH_LST=$(use_with fortran contrib-plugins FortranProject)

	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable pch) \
		${CONF_WITH_LST}
}

pkg_postinst() {
	elog "The Symbols Browser is disabled due to it causing crashes."
	elog "For more information see https://sourceforge.net/p/codeblocks/tickets/225/"

	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
