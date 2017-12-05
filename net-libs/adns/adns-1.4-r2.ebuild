# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib toolchain-funcs

DESCRIPTION="Advanced, easy to use, asynchronous-capable DNS client library and utilities"
HOMEPAGE="http://www.chiark.greenend.org.uk/~ian/adns/"
SRC_URI="ftp://ftp.chiark.greenend.org.uk/users/ian/adns/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"

src_prepare() {
	eapply "${FILESDIR}"/${P}-cnamechain.patch
	# remove bogus test wrt bug #295072
	rm "${S}"/regress/case-cnametocname.sys || die
	eapply_user
}

src_configure() {
	CC=$(tc-getCC) econf
}

src_compile() {
	emake AR=$(tc-getAR) RANLIB=$(tc-getRANLIB)
}

src_install () {
	dodir /usr/{include,bin,$(get_libdir)}
	emake prefix="${ED}"/usr libdir="${ED}"/usr/$(get_libdir) install
	dodoc README TODO changelog "${FILESDIR}"/README.security
	docinto html
	dodoc README.html
	MY_POSTINST_MSG=$(<"${FILESDIR}"/README.security)
}

pkg_postinst() {
	ewarn "${MY_POSTINST_MSG}"
}
