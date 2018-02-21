# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="etPan is a console mail client that is based on libEtPan"
HOMEPAGE="http://www.etpan.org/other.html"
SRC_URI="mirror://sourceforge/libetpan/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug ldap"

RDEPEND=">=net-libs/libetpan-0.35
	sys-libs/ncurses:=
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	virtual/yacc"
PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-tinfo.patch
)
DOCS=(
	Changelog NEWS README TODO contrib/etpan-make-vtree.pl doc/CONFIG
	doc/INTERNAL
)

src_prepare() {
	default
	sed -i -e "s:@bindir@:${D}/@bindir@:" src/Makefile.in || die
	eautoreconf
}

src_configure() {
	econf --disable-debug
}
