# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MY_P="${P/-/_}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Library for downloading files via HTTP using the GET method"
HOMEPAGE="http://http-fetcher.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="debug"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -r '/AC_DEFUN/s/(AC_PATH_HFETCHER)/[\1]/' -i \
		http-fetcher.m4
}

src_compile() {
	econf \
		--disable-strict \
		$(use_enable debug) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dohtml -r docs/index.html docs/html
	dodoc README ChangeLog CREDITS INSTALL
}
