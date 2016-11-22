# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs wxwidgets

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
	"${FILESDIR}/${P}-wx.patch"
	"${FILESDIR}/${P}-no-libtermcap.patch"
	"${FILESDIR}/${P}-texi.patch"
	"${FILESDIR}/${P}-destdir.patch"
	"${FILESDIR}/${P}-optimization-flags.patch"
)

src_prepare() {
	default

	# Drop math.h in two places to fix the build, bug 565122.
	sed -i -e "/math.h/d" coms.c \
		|| die 'failed to drop math.h from coms.c'

	sed -i -e "/math.h/d" graphics.c \
		|| die 'failed to drop math.h from graphics.c'

	if use X ; then
		WX_GTK_VER=2.8 need-wxwidgets unicode

		sed -i -e "s_/usr/local/bin/wx-config_${WX_CONFIG}_g" configure-gtk \
			|| die 'failed to fix wx-config in configure-gtk script'

		sed -i -e 's_--host=gtk__g' configure-gtk \
			|| die 'failed to fix --host in configure-gtk script'
	fi

	sed -i -e "s_/lib/logo_/share/${PN}_" makefile.in \
		|| die 'failed to fix data path in makefile.in'

	sed -i -e "/doc$/s_\$_/${PF}_" docs/makefile \
		|| die 'failed to fix docs path in docs/makefile'

	rm -rf csls/CVS || die 'failed to remove useless CVS directory'
}

src_configure() {
	if use X ; then
		./configure-gtk --prefix=/usr --with-x --wx-enable \
			|| die 'configure script returned an error'
	else
		econf --without-x --wx-disable
	fi
}

src_compile() {
	emake CC="$(tc-getCC)"
}
