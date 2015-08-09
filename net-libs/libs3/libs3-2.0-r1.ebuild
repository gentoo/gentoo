# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
