# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libuninameslist/libuninameslist-20091231.ebuild,v 1.10 2014/06/10 00:56:14 vapier Exp $

EAPI=4

DESCRIPTION="Library of unicode annotation data"
HOMEPAGE="http://libuninameslist.sourceforge.net/"
SRC_URI="mirror://sourceforge/libuninameslist/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

S=${WORKDIR}/${PN}

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
