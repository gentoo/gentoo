# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A port of various original Plan 9 tools for Unix, based on plan9port"
HOMEPAGE="http://tools.suckless.org/9base"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="9base MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	local _objtype=386
	[[ $(tc-arch) == "amd64" ]] && _objtype=x86_64
	[[ $(tc-arch) == "ppc" ]] && _objtype=ppc

	my9baseopts=(
		PREFIX=/usr/plan9
		OBJTYPE=${_objtype}
		AR="$(tc-getAR) rc"
		CC="$(tc-getCC)"
		DESTDIR="${D}"
		)
}

src_prepare() {
	sed -i -e '/strip/d' std.mk {diff,sam}/Makefile || die

	# http://lists.suckless.org/dev/1006/4639.html
	sed -i -e '/-static/d' config.mk || die
}

src_compile() {
	emake "${my9baseopts[@]}"
}

src_install() {
	emake "${my9baseopts[@]}" install
	dodoc README

	# We don't compress to keep support for plan9's man
	docompress -x /usr/plan9/share/man
}
