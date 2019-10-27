# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg-utils

MY_PV=${PV//./}
DESCRIPTION="A very powerful, highly configurable, small editor with syntax coloring"
HOMEPAGE="http://www.scintilla.org/SciTE.html"
SRC_URI="https://www.scintilla.org/${PN}${MY_PV}.tgz -> ${P}.tgz"

LICENSE="HPND lua? ( MIT )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="lua"

RDEPEND="
	dev-libs/glib:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3=
	x11-libs/pango
	lua? ( >=dev-lang/lua-5:= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}/gtk"

pkg_pretend() {
	if tc-is-clang ; then
		# need c++17 features
		[[ "${MERGE_TYPE}" != "binary" &&
		$(clang-major-version) -lt 5 ]] &&
		die "Sorry, SCiTE uses C++17 Features and needs >sys-devel/clang-5
		($(clang-major-version))."

	elif tc-is-gcc; then
		# older gcc is not supported
		[[ "${MERGE_TYPE}" != "binary" &&
		$(gcc-major-version) -lt 7 ]] &&
		die "Sorry, Scite uses C++17 Features, need >sys-devel/gcc-7."
	else
		die "Either gcc or clang should be configured for building scite"
	fi
}

src_prepare() {
	# remove hardcoded CC, Optimizations and clang unknown flags
	sed -i "${WORKDIR}/scintilla/gtk/makefile" \
	-e "s#^CC = gcc#CC = ${CC}#" \
	-e "s#^CC = clang#CC = ${CC}#" \
	-e "s#^CXX = clang++#CC = ${CXX}#" \
	-e "s#-Os##" \
	-e "s#-Wno-misleading-indentation##" \
	|| die "error patching /scintilla/gtk/makefile"

	sed -i "${S}/makefile" \
	-e "s#^CC = clang#CC = ${CC}#" \
	-e "s#^CXX = clang++#CC = ${CXX}#" \
	-e "s#-rdynamic#-rdynamic ${LDFLAGS}#" \
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

	cd "${WORKDIR}" || die "couldn't cd into ${WORKDIR}"
	eapply_user
}

src_compile() {
	# prepare make options
	local emake_pars="GTK3=1"

	if tc-is-clang ; then
		emake_pars+=" CLANG=1"
	fi

	if ! use lua; then
		emake_pars+=" NO_LUA=1"
	fi

	emake -C "${WORKDIR}/scintilla/gtk" "${emake_pars}"
	emake "${emake_pars}"
}

src_install() {
	emake DESTDIR="${ED}" install

	# we have to keep this because otherwise it'll break upgrading
	mv "${ED}/usr/bin/SciTE" "${ED}/usr/bin/scite" || die
	dosym scite /usr/bin/SciTE
	doman ../doc/scite.1
	dodoc ../README
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
