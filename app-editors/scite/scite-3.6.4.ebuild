# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs eutils

MY_PV=${PV//./}
DESCRIPTION="A very powerful editor for programmers"
HOMEPAGE="http://www.scintilla.org/SciTE.html"
SRC_URI="mirror://sourceforge/scintilla/${PN}${MY_PV}.tgz"

LICENSE="HPND lua? ( MIT )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="lua"

RDEPEND="dev-libs/glib:=
	x11-libs/cairo:*
	>=x11-libs/gtk+-2.0:*
	x11-libs/gdk-pixbuf:*
	x11-libs/pango:*
	lua? ( >=dev-lang/lua-5:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-apps/sed-4"

S="${WORKDIR}/${PN}/gtk"

src_prepare() {
	cd "${WORKDIR}/scintilla/gtk"
	sed -i makefile \
		-e "s#^CXXFLAGS=#CXXFLAGS=${CXXFLAGS} #" \
		-e "s#^\(CXXFLAGS=.*\)-Os#\1#" \
		-e "s#^CC =\(.*\)#CC = $(tc-getCXX)#" \
		-e "s#^CCOMP =\(.*\)#CCOMP = $(tc-getCC)#" \
		-e "s#-Os##" \
		|| die "error patching makefile"

	cd "${WORKDIR}/scite/gtk"
	sed -i makefile \
		-e "s#-rdynamic#-rdynamic ${LDFLAGS}#" \
		|| die "error patching makefile"

	# repair and enhance the .desktop file
	sed -i SciTE.desktop \
		-e "s/^Encoding/#Encoding/" \
		-e "s#text/plain#text/\*;application/xhtml+xml#" \
		-e "s#^Categories=\(.*\)#Categories=Development;#" \
		|| die "error patching SciTe.desktop"

	cd "${S}"
	sed -i makefile \
		-e 's#usr/local#usr#g' \
		-e 's#/gnome/apps/Applications#/applications#' \
		-e "s#^CXXFLAGS=#CXXFLAGS=${CXXFLAGS} #" \
		-e "s#^\(CXXFLAGS=.*\)-Os#\1#" \
		-e "s#^CC =\(.*\)#CC = $(tc-getCXX)#" \
		-e "s#^CCOMP =\(.*\)#CCOMP = $(tc-getCC)#" \
		-e 's#${D}##' \
		-e 's#-g root#-g 0#' \
		-e "s#-Os##" \
		|| die "error patching makefile"

	cd "${WORKDIR}"

}

src_compile() {
	emake -C ../../scintilla/gtk AR="$(tc-getAR)"
	if use lua; then
		emake
	else
		emake NO_LUA=1
	fi
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/{pixmaps,applications}

	emake prefix="${ED}/usr" install

	# we have to keep this because otherwise it'll break upgrading
	mv "${ED}/usr/bin/SciTE" "${ED}/usr/bin/scite" || die
	dosym /usr/bin/scite /usr/bin/SciTE

	doman ../doc/scite.1
	dodoc ../README
}
