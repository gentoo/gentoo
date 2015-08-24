# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.com/jq/"
SRC_URI="http://stedolan.github.io/jq/download/source/${P}.tar.gz"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="sys-devel/bison
	sys-devel/flex
	test? ( dev-util/valgrind )"

DOCS=( AUTHORS README )

src_prepare() {
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	# don't try to rebuild docs
	econf --disable-docs
}
