# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI="mirror://gentoo/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc static-libs"
KEYWORDS="~amd64 ~x86"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

PATCHES=( "${FILESDIR}/${PN}-1.3-fix-c++14.patch" )

src_prepare() {
	default
	rm libGenome/gnDefs.cpp || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
