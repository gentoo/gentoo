# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jq/jq-1.4-r1.ebuild,v 1.1 2015/04/07 04:10:41 vapier Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="http://stedolan.github.com/jq/"
SRC_URI="http://stedolan.github.io/jq/download/source/${P}.tar.gz"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

DEPEND="sys-devel/bison
	sys-devel/flex
	test? ( dev-util/valgrind )"

DOCS=( AUTHORS README )

src_prepare() {
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	epatch "${FILESDIR}"/${PN}-1.4-dynamic-link.patch
	eautoreconf
}

src_configure() {
	# don't try to rebuild docs
	econf \
		--disable-docs \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name libjq.la -delete
}
