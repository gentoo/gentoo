# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic gnome2-utils xdg-utils

MY_PV=${PV//./}
DESCRIPTION="A very powerful, highly configurable, small editor with syntax coloring."
HOMEPAGE="http://www.scintilla.org/SciTE.html"
SRC_URI="http://www.scintilla.org/${PN}${MY_PV}.tgz"

LICENSE="HPND lua? ( MIT )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="lua"

RDEPEND="dev-libs/glib:=
	x11-libs/cairo
	x11-libs/gtk+:3=
	x11-libs/gdk-pixbuf
	x11-libs/pango
	lua? ( >=dev-lang/lua-5:= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gcc-7"

S="${WORKDIR}/${PN}/gtk"

src_prepare() {
	sed -i "${WORKDIR}/scintilla/gtk/makefile" \
		-e "s#^CXXFLAGS=#CXXFLAGS=${CXXFLAGS} #" \
		-e "s#^\(CXXFLAGS=.*\)-Os#\1#" \
		-e "s#^CC =\(.*\)#CC = $(tc-getCXX)#" \
		-e "s#^CCOMP =\(.*\)#CCOMP = $(tc-getCC)#" \
		-e "s#-Os##" \
		|| die "error patching /scintilla/gtk/makefile"

	sed -i "${S}/makefile" \
		-e "s#-rdynamic#-rdynamic ${LDFLAGS}#" \
		-e 's#usr/local#usr#g' \
		-e 's#/gnome/apps/Applications#/applications#' \
		-e "s#^CXXFLAGS=#CXXFLAGS=${CXXFLAGS} #" \
		-e "s#^\(CXXFLAGS=.*\)-Os#\1#" \
		-e "s#^CC =\(.*\)#CC = $(tc-getCXX)#" \
		-e "s#^CCOMP =\(.*\)#CCOMP = $(tc-getCC)#" \
		-e 's#${D}##' \
		-e 's#-g root#-g 0#' \
		-e "s#-Os##" \
		|| die "error patching gtk/makefile"

	# repair and enhance the .desktop file
	sed -i "${S}/SciTE.desktop" \
		-e "s#text/plain#text/\*;application/xhtml+xml#" \
		-e "s#^Categories=\(.*\)#Categories=Development;#" \
		|| die "error patching /scite/gtk/SciTe.desktop"

	#  add the ebuild suffix as shell type for working with ebuilds
	sed -i "${WORKDIR}/scite/src/perl.properties" \
		-e "s#\*.sh;\*.bsh;#\*.ebuild;\*.sh;\*.bsh;#" \
		|| die "error patching /scite/src/perl.prperties"

	# it seems that pwd here is ${S}, but user patches are relative to ${workdir}
	# Bug #576162

	cd "${WORKDIR}"
	eapply_user
}

src_compile() {
	# prepare make options
	local emake_pars="GTK3=1"
	if ! use lua; then
		emake_pars+=" NO_LUA=1"
	fi

	emake CC="$(tc-getCC)" LD="$(tc-getLD)" \
			LDFLAGS="$(raw-ldflags)" AR="$(tc-getAR)" \
			-C "${WORKDIR}/scintilla/gtk" $emake_pars
	emake $emake_pars
}

src_install() {
	emake DESTDIR="${ED}" install

	# we have to keep this because otherwise it'll break upgrading
	mv "${ED}/usr/bin/SciTE" "${ED}/usr/bin/scite" || die
	dosym scite /usr/bin/SciTE
	doman ../doc/scite.1
	dodoc ../README
}

pkg_pretend() {
	# older gcc is not supported
	[[ "${MERGE_TYPE}" != "binary" && $(gcc-major-version) -lt 7 ]] && \
		die "Sorry, but gcc earlier than 7.0 will not work for SCiTE."
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
