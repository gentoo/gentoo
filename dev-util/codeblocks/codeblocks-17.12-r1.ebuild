# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"

inherit autotools gnome2-utils wxwidgets xdg-utils

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="http://www.codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tar.xz
https://dev.gentoo.org/~leio/distfiles/${P}-fortran.tar.xz
https://dev.gentoo.org/~leio/distfiles/${P}_update_astyle_plugin_to_v3.1.patch.xz"

# USE="fortran" enables FortranProject plugin (v1.5)
# that is delivered with Code::Blocks 17.12 source code.
# https://sourceforge.net/projects/fortranproject
# http://cbfortran.sourceforge.net

IUSE="contrib debug fortran pch"

RDEPEND="app-arch/zip
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-text/hunspell
		dev-libs/boost:=
	)"

DEPEND="${RDEPEND}
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.0.1-r1:0=
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/codeblocks-17.12-nodebug.diff
	"${WORKDIR}"/patches/
	)

src_prepare() {
	default
	if has_version ">=dev-util/astyle-3.1" ; then
		epatch "${WORKDIR}"/codeblocks-17.12_update_astyle_plugin_to_v3.1.patch
	fi
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
	if [[ ${WX_GTK_VER} == "3.0" || ${WX_GTK_VER} == "3.0-gtk3" ]]; then
		elog "The symbols browser is disabled due to it causing crashes."
		elog "For more information see https://sourceforge.net/p/codeblocks/tickets/225/"
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
