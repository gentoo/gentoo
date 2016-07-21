# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp-common flag-o-matic wxwidgets

DESCRIPTION="a reflective, functional programming language"
HOMEPAGE="https://www.cs.berkeley.edu/~bh/logo.html"
SRC_URI="ftp://ftp.cs.berkeley.edu/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="
	app-text/texi2html
	dev-libs/libbsd
	virtual/tex-base
	virtual/texi2dvi
	X? ( x11-libs/wxGTK:2.8[X] )"

PATCHES=(
	"${FILESDIR}"/${P}-wx.patch
	"${FILESDIR}"/${P}-no-libtermcap.patch
	"${FILESDIR}"/${P}-texi.patch
	"${FILESDIR}"/${P}-destdir.patch
)

src_prepare() {
	default

	sed -i -e "/math.h/d" coms.c || die
	sed -i -e "/math.h/d" graphics.c || die

	WX_GTK_VER=2.8 need-wxwidgets unicode
	sed -i -e "s_/usr/local/bin/wx-config_${WX_CONFIG}_g" configure-gtk || die
	sed -i -e 's_--host=gtk__g' configure-gtk || die
	sed -i -e "s_/lib/logo_/lib/${P}_" makefile.in || die
	sed -i -e "/doc$/s_\$_/${P}_" docs/makefile || die

	rm -rf csls/CVS || die
}

src_configure() {
	local confsuffix

	use X && confsuffix="-gtk"
	"./configure${confsuffix}" --prefix=/usr $(use_with X x) || die
}

src_compile() {
	strip-flags
	emake CC="$(tc-getCC)" everything
}
