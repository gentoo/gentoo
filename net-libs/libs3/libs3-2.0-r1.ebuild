# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libs3/libs3-2.0-r1.ebuild,v 1.1 2012/11/10 11:21:40 jlec Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="A C Library API for Amazon S3"
HOMEPAGE="http://libs3.ischo.com.s3.amazonaws.com/index.html"
SRC_URI="http://libs3.ischo.com.s3.amazonaws.com/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	net-misc/curl
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	sed \
		-e "s:/lib/:/$(get_libdir)/:g" \
		-i *makefile* || die
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}/usr" install
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*a
}
