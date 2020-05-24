# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple but powerful unit testing framework for C++"
HOMEPAGE="https://github.com/cpptest/cpptest"
SRC_URI="https://github.com/cpptest/cpptest/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"  # for soversion 1.x.x
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND="!dev-util/cpptest:0"

DOCS=( AUTHORS BUGS NEWS README )

src_configure() {
	econf $(use_enable doc) $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
