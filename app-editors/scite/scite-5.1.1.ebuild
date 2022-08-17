# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )

inherit lua-single toolchain-funcs xdg

DESCRIPTION="A very powerful, highly configurable, small editor with syntax coloring"
HOMEPAGE="https://www.scintilla.org/SciTE.html"
SRC_URI="https://www.scintilla.org/${PN}${PV//./}.tgz -> ${P}.tgz"

LICENSE="HPND lua? ( MIT )"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="lua"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	lua? ( ${LUA_DEPS} )"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig"

DOCS=("../README")

S="${WORKDIR}/${PN}/gtk"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	tc-export AR CC CXX RANLIB

	# remove hardcoded CC, Optimizations and clang unknown flags
	sed -i "${WORKDIR}/scintilla/gtk/makefile" \
	-e "s#^CC = gcc#CC = ${CC}#" \
	-e "s#^CC = clang#CC = ${CC}#" \
	-e "s#^CXX = clang++#CXX = ${CXX}#" \
	-e "s#-Os##" \
	-e "s#-Wno-misleading-indentation##" \
	|| die "error patching /scintilla/gtk/makefile"

	sed -i "${S}/makefile" \
	-e "s#^CC = clang#CC = ${CC}#" \
	-e "s#^CXX = clang++#CXX = ${CXX}#" \
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
	|| die "error patching /scite/src/perl.properties"

	# it seems that pwd here is ${S}, but user patches are relative to ${workdir}
	# Bug #576162

	cd "${WORKDIR}" || die "couldn't cd into ${WORKDIR}"
	eapply_user
}

src_compile() {
	# prepare make options
	local emake_pars=("GTK3=1")

	tc-is-clang && emake_pars+=("CLANG=1")
	use !lua    && emake_pars+=("NO_LUA=1")

	emake -C "${WORKDIR}/lexilla/src" "${emake_pars[@]}"
	emake -C "${WORKDIR}/scintilla/gtk" "${emake_pars[@]}"
	emake "${emake_pars[@]}"
}

# want to use the base src_install() as base_src_install()

src_install() {
	default
	dosym SciTE /usr/bin/scite
}
