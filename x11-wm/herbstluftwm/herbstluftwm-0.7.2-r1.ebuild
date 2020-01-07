# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs bash-completion-r1

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/herbstluftwm/herbstluftwm.git"
	BDEPEND="app-text/asciidoc"
else
	SRC_URI="https://herbstluftwm.org/tarballs/${P}.tar.gz"
	KEYWORDS="amd64 x86"
	BDEPEND=""
fi

DESCRIPTION="A manual tiling window manager for X"
HOMEPAGE="https://herbstluftwm.org/"

LICENSE="BSD-2"
SLOT="0"
IUSE="examples xinerama zsh-completion"

DEPEND="
	>=dev-libs/glib-2.24:2
	x11-libs/libX11
	x11-libs/libXext
	xinerama? ( x11-libs/libXinerama )
"
RDEPEND="
	${DEPEND}
	app-shells/bash
	zsh-completion? ( app-shells/zsh )
"
BDEPEND+="
	virtual/pkgconfig
"

src_compile() {
	tc-export CC CXX LD PKG_CONFIG

	emake LDXX="$(tc-getCXX)" COLOR=0 VERBOSE= \
		$(use xinerama || echo XINERAMAFLAGS= XINERAMALIBS= )
}

src_install() {
	dobin herbstluftwm herbstclient
	dodoc BUGS MIGRATION NEWS README.md

	doman doc/{herbstluftwm,herbstclient}.1

	exeinto /etc/xdg/herbstluftwm
	doexe share/{autostart,panel.sh,restartpanels.sh}

	insinto /usr/share/xsessions
	doins share/herbstluftwm.desktop

	newbashcomp share/herbstclient-completion herbstclient

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins share/_herbstclient
	fi

	if use examples ; then
		exeinto /usr/share/doc/${PF}/examples
		doexe scripts/*.sh
		docinto examples
		dodoc scripts/README
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
