# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tokyodystopia/tokyodystopia-0.9.15.ebuild,v 1.1 2010/08/13 10:59:38 patrick Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A fulltext search engine for Tokyo Cabinet"
HOMEPAGE="http://fallabs.com/tokyodystopia/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-db/tokyocabinet"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/fix_rpath.patch"
	epatch "${FILESDIR}/fix_ldconfig.patch"
	epatch "${FILESDIR}/remove_docinst.patch"
}

src_configure() {
	econf --libexecdir=/usr/libexec/${PN} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dohtml doc/* || die

	if use examples; then
		insinto /usr/share/${PF}/example
		doins example/* || die "Install failed"
	fi

}

src_test() {
	emake -j1 check || die "Tests failed"
}
