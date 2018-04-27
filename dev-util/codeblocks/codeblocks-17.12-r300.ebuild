# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0-gtk3"

inherit autotools flag-o-matic gnome2-utils wxwidgets xdg-utils

DESCRIPTION="The open source, cross platform, free C++ IDE"
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tar.xz https://dev.gentoo.org/~leio/distfiles/${P}-fortran.tar.xz"

# USE="fortran" enables FortranProject plugin (v1.5)
# that is delivered with Code::Blocks 17.12 source code.
# https://sourceforge.net/projects/fortranproject
# http://cbfortran.sourceforge.net

IUSE="contrib debug fortran pch"

RDEPEND="app-arch/zip
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-text/hunspell
		dev-libs/boost:=
		dev-libs/libgamin
	)"

DEPEND="${RDEPEND}
	sys-devel/autoconf:2.69
	sys-devel/automake
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/codeblocks-17.12-nodebug.diff
	"${WORKDIR}"/patches/
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets

	append-cxxflags $(test-flags-CXX -fno-delete-null-pointer-checks)

	# USE="contrib -fortran" setup:
	use fortran || CONF_WITH_LST=$(use_with contrib contrib-plugins all,-FortranProject)
	# USE="contrib fortran" setup:
	use fortran && CONF_WITH_LST=$(use_with contrib contrib-plugins all)
	# USE="-contrib fortran" setup:
	use contrib || CONF_WITH_LST=$(use_with fortran contrib-plugins FortranProject)

	econf \
		--with-wx-config="${WX_CONFIG}" \
		--disable-static \
		$(use_enable debug) \
		$(use_enable pch) \
		${CONF_WITH_LST}
}

pkg_postinst() {
	if [[ ${WX_GTK_VER} == "3.0" || ${WX_GTK_VER} == "3.0-gtk3" ]]; then
		elog "KNOWN ISSUE:"
		elog "The symbols browser is disabled in wx3.x builds due to it causes crashes."
		elog "For more information see ticket https://sourceforge.net/p/codeblocks/tickets/225/"
		elog "with related commits https://sourceforge.net/p/codeblocks/code/11027/"
		elog "and https://sourceforge.net/p/codeblocks/code/11141/"
	fi

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
