# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

DESCRIPTION="Advanced, easy to use, asynchronous-capable DNS client library and utilities"
HOMEPAGE="http://www.chiark.greenend.org.uk/~ian/adns/"
SRC_URI="ftp://ftp.chiark.greenend.org.uk/users/ian/adns/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	CC=$(tc-getCC) econf || die "econf failed"
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
