# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/newsbeuter/newsbeuter-2.9.ebuild,v 1.2 2015/07/08 00:17:43 radhermit Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="A RSS/Atom feed reader for the text console"
HOMEPAGE="http://www.newsbeuter.org/index.html"
SRC_URI="http://www.${PN}.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

RDEPEND=">=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.18.0
	dev-libs/json-c:=
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	sys-devel/gettext
	test? (
		dev-libs/boost
		sys-devel/bc
	)"

# tests require network access
RESTRICT="test"

src_prepare() {
	sed -i 's:-ggdb::' Makefile || die
}

src_configure() {
	./config.sh || die
}

src_compile() {
	emake CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

src_test() {
	emake test
	# Tests fail if in ${S} rather than in ${S}/test
	cd "${S}"/test
	./test || die
}

src_install() {
	emake prefix="${D}/usr" docdir="${D}/usr/share/doc/${PF}" install
	dodoc AUTHORS README CHANGES
}
