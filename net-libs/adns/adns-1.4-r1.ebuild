# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/adns/adns-1.4-r1.ebuild,v 1.3 2012/05/09 16:46:12 aballier Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Advanced, easy to use, asynchronous-capable DNS client library and utilities"
HOMEPAGE="http://www.chiark.greenend.org.uk/~ian/adns/"
SRC_URI="ftp://ftp.chiark.greenend.org.uk/users/ian/adns/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-cnamechain.patch
	#remove bogus test wrt bug #295072
	rm "${S}"/regress/case-cnametocname.sys
}

src_configure() {
	CC=$(tc-getCC) econf || die "econf failed"
}

src_compile() {
	emake AR=$(tc-getAR) RANLIB=$(tc-getRANLIB) || die "emake failed"
}

src_install () {
	dodir /usr/{include,bin,$(get_libdir)}
	emake prefix="${D}"/usr libdir="${D}"/usr/$(get_libdir) install || die "emake install failed"
	dodoc README TODO changelog "${FILESDIR}"/README.security
	dohtml *.html
}

pkg_postinst() {
	ewarn "$(<${FILESDIR}/README.security)"
}
