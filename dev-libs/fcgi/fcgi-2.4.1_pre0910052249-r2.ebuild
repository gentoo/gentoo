# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/fcgi/fcgi-2.4.1_pre0910052249-r2.ebuild,v 1.10 2015/02/24 10:56:40 ago Exp $

EAPI="4"

inherit eutils autotools multilib

DESCRIPTION="FastCGI Developer's Kit"
HOMEPAGE="http://www.fastcgi.com/"
SRC_URI="http://www.fastcgi.com/dist/fcgi-2.4.1-SNAP-0910052249.tar.gz"

LICENSE="FastCGI"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="html"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/fcgi-2.4.1-SNAP-0910052249"

src_prepare() {
	epatch "${FILESDIR}/fcgi-2.4.0-Makefile.patch"
	epatch "${FILESDIR}/fcgi-2.4.0-clientdata-pointer.patch"
	epatch "${FILESDIR}/fcgi-2.4.0-html-updates.patch"
	epatch "${FILESDIR}"/fcgi-2.4.1_pre0311112127-gcc44.patch
	epatch "${FILESDIR}"/${P}-link.patch
	epatch "${FILESDIR}"/${P}-poll.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install LIBRARY_PATH="${ED}/usr/$(get_libdir)"

	dodoc README

	# install the manpages into the right place
	doman doc/*.[13]

	# Only install the html documentation if USE=html
	if use html ; then
		dohtml "${S}"/doc/*/*
		insinto /usr/share/doc/${PF}/html
		doins -r "${S}/images"
	fi

	# install examples in the right place
	insinto /usr/share/doc/${PF}/examples
	doins "${S}/examples/"*.c
}
