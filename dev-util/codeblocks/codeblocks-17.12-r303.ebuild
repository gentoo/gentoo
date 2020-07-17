# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit autotools wxwidgets xdg-utils

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tar.xz
https://dev.gentoo.org/~leio/distfiles/${P}-fortran.tar.xz
https://dev.gentoo.org/~leio/distfiles/${P}_update_astyle_plugin_to_v3.1.patch.xz"

# USE="fortran" enables FortranProject plugin (v1.5)
# that is delivered with Code::Blocks 17.12 source code.
# https://sourceforge.net/projects/fortranproject
# http://cbfortran.sourceforge.net

IUSE="contrib debug fortran pch"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-arch/zip
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.0.1-r1:0=
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-text/hunspell
		dev-libs/boost:=
	)"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-crash-on-copypaste.patch
	"${FILESDIR}"/${P}-nodebug.diff
	"${WORKDIR}"/patches/
	)

src_prepare() {
	default
	if has_version ">=dev-util/astyle-3.1" ; then
		eapply "${WORKDIR}"/codeblocks-17.12_update_astyle_plugin_to_v3.1.patch
	fi
	sed -i "s:appdatadir = \$(datarootdir)/appdata:appdatadir = \$(datarootdir)/metainfo:" Makefile.am || die # bug 709450
	sed -i "s:appdatadir = \$(datarootdir)/appdata:appdatadir = \$(datarootdir)/metainfo:" src/plugins/contrib/appdata/Makefile.am || die # bug 709450
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

	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
