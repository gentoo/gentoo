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

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	sed -i -e "s:@bindir@:${D}/@bindir@:" src/Makefile.in

	econf \
		`use_enable debug` \
			|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc Changelog NEWS README TODO contrib/etpan-make-vtree.pl doc/*
}
